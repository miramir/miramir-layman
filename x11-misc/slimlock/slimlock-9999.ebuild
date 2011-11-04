# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="screen locker borrowing the interface of the SLiM login-manager"
HOMEPAGE="http://programsthatsmellgood.com/slimlock/"
SRC_URI="https://github.com/joelburget/slimlock/tarball/master -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXft
	media-libs/freetype
	media-libs/imlib2
	virtual/pam"
RDEPEND="${DEPEND}
	x11-misc/slim[pam]"

src_unpack() {
	default_src_unpack
	# to address the github hash
	mv *-${PN}-* "${S}"
}

src_prepare() {
	#	-e "s/PKGS=/PKGS=freetype2 /" \
	sed -i \
		-e "s/-o \$(NAME)/-o \$(NAME) \$(LIBS)/" \
		-e "/MANDIR/d" \
		Makefile || die "sed failed"
}

src_compile() {
	emake	CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		VERSION=${PV} \
		PREFIX="${EPREFIX}"/usr \
		CFGDIR="${EPREFIX}"/etc
}

src_install() {
	default_src_install
	doman ${PN}.1
}
