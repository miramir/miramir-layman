# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/gmrun/gmrun-0.9.2-r1.ebuild,v 1.3 2011/04/15 17:36:56 ssuominen Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="A GTK-2 based launcher box with bash style auto completion!"
HOMEPAGE="http://sourceforge.net/projects/gmrun/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="elibc_glibc"

RDEPEND="x11-libs/gtk+:2
	dev-libs/popt"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-apps/sed
	elibc_glibc? ( >=sys-libs/glibc-2.10 )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-sysconfdir.patch \
		"${FILESDIR}"/${P}-glibc210.patch \
		"${FILESDIR}"/${P}-termcommand.patch \
		"${FILESDIR}"/${P}-centered_window.patch

	# Disable check for STLport due to bug #164339
	sed -i -e 's,^AC_PATH_STLPORT,dnl REMOVED ,g' configure.in
	sed -i -e 's,@STLPORT_[A-Z]\+@,,g' src/Makefile.am
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS
}
