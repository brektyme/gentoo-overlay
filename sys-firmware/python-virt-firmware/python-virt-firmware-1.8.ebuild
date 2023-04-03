# shellcheck disable=SC2034
EAPI=8

PYTHON_COMPAT=(python3_{9,10,11})
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1
DESCRIPTION="Tools for virtual machine firmware volumes"

HOMEPAGE="https://gitlab.com/kraxel/virt-firmware"
SRC_URI="https://gitlab.com/kraxel/virt-firmware/-/archive/v${PV}/virt-firmware-v${PV}.tar.bz2 -> ${P}-${PV}.gl.tar.bz2"

S="${WORKDIR}/virt-firmware-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="
+doc
"
BDEPENDS="
	${PYTHON_DEPS},
	doc? (sys-apps/help2man),
"

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install
	if use doc; then
		insinto /usr/share/man1
		doins man/*.1
	fi
}
