# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Fuse-filesystem to bind-mount a directory with adjusted permissions"
HOMEPAGE="http://code.google.com/p/bindfs/"
SRC_URI="http://bindfs.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-fs/fuse-2.5.3"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
	dodoc ChangeLog README TODO || die 'dodoc failed'
}
