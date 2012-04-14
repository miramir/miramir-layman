inherit eutils
DESCRIPTION="PyCharm"
HOMEPAGE="www.jetbrains.com/pycharm/"
SRC_URI="http://download.jetbrains.com/python/pycharm-${PV}.tar.gz"
KEYWORDS="x86 amd64"
DEPEND=">=virtual/jre-1.6"
RDEPEND="${DEPEND}"
SLOT="0"
EAPI="4"
src_install() {	
	dodir /opt/${PN}
	
	insinto /opt/${PN}
	doins -r *
	fperms a+x /opt/${PN}/bin/pycharm.sh || die "fperms failed"
	dosym /opt/${PN}/bin/pycharm.sh /usr/bin/pycharm

	cp bin/PyCharm_32.png bin/PyCharm.png
	doicon "bin/PyCharm.png"
	make_desktop_entry ${PN} "PyCharm" "PyCharm"
}
pkg_postinst() {
    elog "Run /usr/bin/pycharm"
}

