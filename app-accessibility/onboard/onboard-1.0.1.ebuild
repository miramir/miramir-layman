# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND=2
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS='2.4 2.5 3.*'

inherit gnome2-utils distutils versionator

DESCRIPTION="Simple on-screen Keyboard with macros and easy layout creation"
HOMEPAGE="https://launchpad.net/onboard"
SRC_URI="http://launchpad.net/${PN}/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-distutils-extra"
RDEPEND="dev-python/gconf-python
	dev-python/pyxml
	dev-python/python-virtkey
	x11-libs/cairo[svg]"

PYTHON_MODNAME="Onboard"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
