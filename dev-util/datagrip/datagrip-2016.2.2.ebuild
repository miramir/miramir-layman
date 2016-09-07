EAPI=5
inherit eutils

#EAP_VERSION='EAP-162.426.10'

HOMEPAGE="https://www.jetbrains.com/datagrip/"
DESCRIPTION="Your Swiss Army Knife for Databases and SQL from JetBrains"
SRC_URI="https://download.jetbrains.com/datagrip/datagrip-${EAP_VERSION:-${PV}}.tar.gz"

if [[ x${EAP_VERSION} != 'x' ]]; then
	KEYWORDS="x86 amd64"
else
	KEYWORDS="~x86 ~amd64"
fi

PROGNAME="DataGrip"

RESTRICT="strip mirror"
DEPEND=">=virtual/jre-1.6"
SLOT="0"
S=${WORKDIR}

src_install() {
	dodir /opt/${PN}

	cd DataGrip*/
	sed -i 's/IS_EAP="true"/IS_EAP="false"/' bin/datagrip.sh
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/datagrip.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/inspect.sh || die "Chmod failed"
	dosym /opt/${PN}/bin/datagrip.sh /usr/bin/${PN}

	mv "bin/product.png" "bin/${PN}.png"
	doicon "bin/${PN}.png"
	make_desktop_entry ${PN} "${PROGNAME}" "${PN}"
}

pkg_postinst() {
    elog "Run /usr/bin/${PN}"
}


