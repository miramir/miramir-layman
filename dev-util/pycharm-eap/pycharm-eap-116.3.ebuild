inherit eutils
DESCRIPTION="PyCharm"
HOMEPAGE="www.jetbrains.com/pycharm/"
SRC_URI="http://download.jetbrains.com/python/pycharm-${PV}.tar.gz"
KEYWORDS="~x86 ~amd64"
DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"
RESTRICT="strip mirror"
SLOT="0"
EAPI="4"
S=${WORKDIR}
src_install() {	
	dodir /opt/${PN}
		
	insinto /opt/${PN}
	cd pycharm-${PV}
	doins -r *
	fperms a+x /opt/${PN}/bin/pycharm.sh || die "fperms failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "fperms failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "fperms failed"
	fperms a+x /opt/${PN}/bin/inspect.sh || die "fperms failed"
	fperms a+x /opt/${PN}/bin/inspect_diff.sh || die "fperms failed"
	dosym /opt/${PN}/bin/pycharm.sh /usr/bin/pycharm-eap

	cp bin/PyCharm_32.png bin/PyCharm-EAP.png
	doicon "bin/PyCharm-EAP.png"
	make_desktop_entry ${PN} "PyCharm-EAP" "PyCharm-EAP"
}
pkg_postinst() {
    elog "Run /usr/bin/pycharm-eap"
}

