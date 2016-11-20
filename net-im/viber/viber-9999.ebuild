# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils
DESCRIPTION="Free calls, text and picture sharing with anyone, anywhere!"
HOMEPAGE="https://www.viber.com"
SRC_URI="http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="strip"
S="${WORKDIR}"

src_prepare() {
		unpack ./control.tar.gz
		unpack ./data.tar.xz

		eapply "${FILESDIR}/${PN}-9999-desktop.patch"
		eapply_user
		
}

src_install() {
		doins -r opt usr
		fperms 0755 /opt/viber/Viber
}
