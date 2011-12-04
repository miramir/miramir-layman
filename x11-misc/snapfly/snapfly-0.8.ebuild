# Copyright 2010-2011 Drakmail
# Distributed under the terms of the GNU General Public License v3

EAPI=3
PYTHON_DEPEND="2"
inherit python distutils gnome2-utils

DESCRIPTION="SnapFly is a lightweight PyGTK menu which can be run as a daemon"
HOMEPAGE="http://code.google.com/p/snapfly/"
SRC_URI="http://snapfly.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-lang/python-2.6
	dev-python/dbus-python
	dev-python/pyinotify
	dev-python/pygtk"
DEPEND="${RDEPEND}"

S=${WORKDIR}/snapfly

pkg_preinst() {
        gnome2_icon_savelist
}
 
pkg_postinst() {
        gnome2_icon_cache_update
        distutils_pkg_postinst
}

DOCS="AUTHORS COPYING ChangeLog VERSION"
