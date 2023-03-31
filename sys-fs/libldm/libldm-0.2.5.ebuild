# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Gives access to Microsoft Windows dynamic disks, aka LDM, similar to LVM"
HOMEPAGE="https://github.com/mdbooth/libldm/"
SRC_URI="https://github.com/mdbooth/libldm/archive/refs/tags/libldm-0.2.5.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PN}-${PV}"

DEPEND="
	>=dev-libs/glib-2.26.0
	>=dev-libs/json-glib-0.14.0
	sys-fs/lvm2
	sys-libs/zlib
	"
BDEPEND="
	dev-libs/libxslt
	dev-util/gtk-doc
"

#PATCHES=( "${FILESDIR}/Remove-deprecated-g_type_class_add_private.patch" "${FILESDIR}/Replace-_GET_PRIVATE-macros-with-_get_instance_priva.patch" )
# PATCHES=( "${FILESDIR}/libldmguysmoilovgitchangesupto20032020.patch" )
src_prepare() {
	default
	eautoreconf
}
