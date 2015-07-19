EAPI=4
inherit eutils
#PVERSION='8.0.3'
EAP=''
#EAP="-6-Preview"

HOMEPAGE="https://www.jetbrains.com/dbe/"
DESCRIPTION="Smart SQL Editor and Advanced Database Client by JetBrains"
SRC_URI="http://download.jetbrains.com/dbe/0xdbe${EAP}-${PVERSION:-${PV}}.tar.gz"

if [[ x${PVERSION} != 'x' ]]; then
	KEYWORDS="x86 amd64"
else
	KEYWORDS="~x86 ~amd64"
fi

PROGNAME="0xdbe"

RESTRICT="strip mirror"
DEPEND=">=virtual/jre-1.6"
SLOT="0"
S=${WORKDIR}

src_install() {
	dodir /opt/${PN}

	cd 0xDBE*/
	sed -i 's/IS_EAP="true"/IS_EAP="false"/' bin/0xdbe.sh
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/0xdbe.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "Chmod failed"
	dosym /opt/${PN}/bin/0xdbe.sh /usr/bin/${PN}
	
	mv "bin/0xdbe.png" "bin/${PN}.png"
	doicon "bin/${PN}.png"
	make_desktop_entry ${PN} "${PROGNAME}" "${PN}"
}

pkg_postinst() {
    elog "Run /usr/bin/${PN}"
}


