# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils unpacker

DESCRIPTION="The smart to-do app for busy people."
HOMEPAGE="https://www.rememberthemilk.com"
SRC_URI="https://www.rememberthemilk.com/download/linux/debian/pool/main/r/rememberthemilk/rememberthemilk-${PV}.deb"

LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	cp -Rp usr "${D}"
	cp -Rp opt "${D}"
}
