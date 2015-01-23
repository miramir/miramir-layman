# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="X11 keyboard indicator and switcher"
HOMEPAGE="http://sourceforge.net/projects/gxkb/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/libwnck:1
	x11-libs/libxklavier
"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}
"
