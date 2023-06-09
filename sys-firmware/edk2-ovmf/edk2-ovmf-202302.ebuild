# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# shellcheck disable=SC2034

EAPI=8

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=(python3_{9,10,11})

inherit python-any-r1 readme.gentoo-r1

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

BUNDLED_OPENSSL_SUBMODULE_SHA="129058165d195e43a0ad10111b0c2e29bdf65980"
BUNDLED_BROTLI_SUBMODULE_SHA="f4153a09f87cbb9c826d8fc12c74642bb2d879ea"
DBXUPDATE_VERSION="20230314"

# TODO: talk with tamiko about unbundling (mva)

# TODO: the binary 202105 package currently lacks the preseeded
#       OVMF_VARS.secboot.fd file (that we typically get from fedora)

SRC_URI="https://github.com/tianocore/edk2/archive/refs/tags/edk2-stable${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/openssl/openssl/archive/${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz -> openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz
	https://github.com/google/brotli/archive/${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz -> brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz
	https://github.com/fwupd/dbx-firmware/blob/master/DBXUpdate-${DBXUPDATE_VERSION}.x64.bin?raw=true -> DBXUpdate.x64.bin
	"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="make-iso"

BDEPEND="app-emulation/qemu
	>=dev-lang/nasm-2.0.7
	>=sys-power/iasl-20160729
	sys-firmware/python-virt-firmware
	make-iso? (
		dev-libs/libisoburn
		sys-fs/mtools
		sys-fs/dosfstools
	)
	${PYTHON_DEPS}"
RDEPEND="!sys-firmware/edk2-ovmf-bin"

PATCHES=(
	"${FILESDIR}/${PN}-${PV}-werror.patch"
)

S="${WORKDIR}/edk2-edk2-stable${PV}"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="This package contains the tianocore edk2 UEFI firmware for 64-bit x86
virtual machines. The firmware is located under
	/usr/share/edk2-ovmf/OVMF_CODE.fd
	/usr/share/edk2-ovmf/OVMF_VARS.fd
	/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd

If USE=binary is enabled, we also install an OVMF variables file (coming from
fedora) that contains secureboot default keys

	/usr/share/edk2-ovmf/OVMF_VARS.secboot.fd

If you have compiled this package by hand, you need to either populate all
necessary EFI variables by hand by booting
	/usr/share/edk2-ovmf/UefiShell.(iso|img)
or creating OVMF_VARS.secboot.fd by hand:
	https://github.com/puiterwijk/qemu-ovmf-secureboot

The firmware does not support csm (due to no free csm implementation
available). If you need a firmware with csm support you have to download
one for yourself. Firmware blobs are commonly labeled
	OVMF{,_CODE,_VARS}-with-csm.fd

In order to use the firmware you can run qemu the following way

	$ qemu-system-x86_64 \
		-drive file=/usr/share/edk2-ovmf/OVMF.fd,if=pflash,format=raw,unit=0,readonly=on \
		..."

src_prepare() {
	# Bundled submodules
	cp -rl "${WORKDIR}/openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}"/* "CryptoPkg/Library/OpensslLib/openssl/"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* "BaseTools/Source/C/BrotliCompress/brotli/"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* "MdeModulePkg/Library/BrotliCustomDecompressLib/brotli/"
	mv "${DISTDIR}/DBXUpdate.x64.bin" "${WORKDIR}"
	tar -xJf "${FILESDIR}/${P}-qemu-firmware.tar.xz"

	sed -i -r \
		-e "/function SetupPython3/,/\}/{s,\\\$\(whereis python3\),${EPYTHON},g}" \
		"${S}"/edksetup.sh || die "Fixing for correct Python3 support failed"

	default
}

build_iso() {
	dir="$1"
	UEFI_SHELL_BINARY=${dir}/Shell.efi
	ENROLLER_BINARY=${dir}/EnrollDefaultKeys.efi
	UEFI_SHELL_IMAGE=uefi_shell.img
	ISO_IMAGE=${dir}/UefiShell.iso

	UEFI_SHELL_BINARY_BNAME=$(basename -- "$UEFI_SHELL_BINARY")
	UEFI_SHELL_SIZE=$(stat --format=%s -- "$UEFI_SHELL_BINARY")
	ENROLLER_SIZE=$(stat --format=%s -- "$ENROLLER_BINARY")

	# add 1MB then 10% for metadata
	UEFI_SHELL_IMAGE_KB=$(((\
		UEFI_SHELL_SIZE + ENROLLER_SIZE + 1 * 1024 * 1024) * 11 / 10 / 1024))

	# create non-partitioned FAT image
	rm -f -- "$UEFI_SHELL_IMAGE"
	mkfs.fat -C "$UEFI_SHELL_IMAGE" -n UEFI_SHELL -- "$UEFI_SHELL_IMAGE_KB"

	# copy the shell binary into the FAT image
	export MTOOLS_SKIP_CHECK=1
	mmd -i "$UEFI_SHELL_IMAGE" ::efi
	mmd -i "$UEFI_SHELL_IMAGE" ::efi/boot
	mcopy -i "$UEFI_SHELL_IMAGE" "$UEFI_SHELL_BINARY" ::efi/boot/bootx64.efi
	mcopy -i "$UEFI_SHELL_IMAGE" "$ENROLLER_BINARY" ::
	mdir -i "$UEFI_SHELL_IMAGE" -/ ::

	# build ISO with FAT image file as El Torito EFI boot image
	xorrisofs -input-charset ASCII -J -rational-rock \
		-e "$UEFI_SHELL_IMAGE" -no-emul-boot \
		-o "$ISO_IMAGE" "$UEFI_SHELL_IMAGE"
}

src_compile() {
	TARGET_ARCH=X64
	TARGET_NAME=RELEASE
	TARGET_TOOLS=GCC5

	BUILD_FLAGS="-D TLS_ENABLE \
		-D HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D TPM_ENABLE \
		-D TPM2_ENABLE -D TPM2_CONFIG_ENABLE \
		-D FD_SIZE_2MB"

	SECUREBOOT_BUILD_FLAGS="${BUILD_FLAGS} \
		-D SECURE_BOOT_ENABLE \
		-D SMM_REQUIRE \
		-D EXCLUDE_SHELL_FROM_FD"

	emake ARCH=${TARGET_ARCH} -C BaseTools

	# shellcheck disable=SC1091
	source ./edksetup.sh

	# Build all EFI firmware blobs:

	mkdir -p ovmf

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		"${BUILD_FLAGS}" || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_*.fd ovmf/
	rm -rf Build/OvmfX64

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		"${SECUREBOOT_BUILD_FLAGS}" || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_CODE.fd ovmf/OVMF_CODE.secboot.fd || die "cp failed"
	cp Build/OvmfX64/*/X64/Shell.efi ovmf/ || die "cp failed"
	cp Build/OvmfX64/*/X64/EnrollDefaultKeys.efi ovmf || die "cp failed"

	virt-fw-vars --input ovmf/OVMF_VARS.fd \
		--output ovmf/OVMF_VARS.secboot.fd \
		--set-dbx "${DISTDIR}"/DBXUpdate.x64.bin \
		--enroll-redhat --secure-boot || die "unable to enroll certificates for secure boot"

	# Build a convenience UefiShell.img:

	mkdir -p iso_image/efi/boot || die "mkdir failed"
	cp ovmf/Shell.efi iso_image/efi/boot/bootx64.efi || die "cp failed"
	cp ovmf/EnrollDefaultKeys.efi iso_image || die "cp failed"
	cp ovmf/OVMF_VARS.secboot.fd iso_image || die "cp failed"
	qemu-img convert --image-opts \
		driver=vvfat,floppy=on,fat-type=12,label=UEFI_SHELL,dir=iso_image \
		ovmf/UefiShell.img || die "qemu-img failed"

	if use make-iso; then
		build_iso ovmf
	fi
}

src_install() {
	insinto /usr/share/edk2/ovmf
	doins ovmf/*

	insinto /usr/share/qemu/firmware
	doins qemu/*

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
