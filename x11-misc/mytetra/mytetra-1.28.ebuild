# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/qtfm/qtfm-4.9.ebuild,v 1.1 2011/04/10 12:58:54 ssuominen Exp $

EAPI=2
inherit versionator eutils qt4-r2

MY_P=${PN}_$(replace_version_separator 1 '_')

DESCRIPTION="Smart manager for information collecting"
HOMEPAGE="http://webhamster.ru/site/page/index/articles/projectcode/"
SRC_URI="http://webhamster.ru/db/data/articles/105/${MY_P}_src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}_src"

src_install() {
	qt4-r2_src_install
	domenu desktop/mytetra.desktop
	doicon desktop/mytetra.png
}

