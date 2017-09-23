# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils unpacker
DESCRIPTION="Free calls, text and picture sharing with anyone, anywhere!"
HOMEPAGE="http://www.viber.com"
SRC_URI="http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb"

SLOT="0"
KEYWORDS=""
IUSE="pulseaudio +apulse"
REQUIRED_USE="apulse? ( !pulseaudio )"
RESTRICT="strip"
QA_PREBUILT="*"

RESTRICT="mirror bindist strip"
RDEPEND="
        apulse? ( media-sound/apulse )
        pulseaudio? ( media-sound/pulseaudio )
"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install(){
	doins -r opt usr

    if use apulse; then
        mv ${ED}/opt/${PN}/Viber ${ED}/opt/${PN}/${PN}-bin
        insinto opt/${PN}
        doins "${FILESDIR}/${PN}"
        fowners root:audio /opt/${PN}/${PN} /opt/${PN}/${PN}-bin
        fperms 755 /opt/${PN}/${PN} /opt/${PN}/${PN}-bin
        sed -i -e '/^Exec/s/Viber/viber/' ${ED}/usr/share/applications/viber.desktop
    else
        fperms 755 /opt/${PN}/Viber
    fi
}

