# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools

DESCRIPTION="A lightweight logout screen for openbox"
HOMEPAGE="http://sourceforge.net/projects/staybox/"
SRC_URI="http://sourceforge.net/projects/staybox/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-power/upower
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.65"

src_prepare() {
	epatch "${FILESDIR}"/${P}-doc.patch
	epatch "${FILESDIR}"/extra-settings.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS ChangeLog
}
