# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/vsftpd/vsftpd-3.0.2-r1.ebuild,v 1.1 2013/04/20 16:51:02 hwoarang Exp $

EAPI="4"

inherit eutils systemd toolchain-funcs

DESCRIPTION="Very Secure FTP Daemon with devnet patchset"
HOMEPAGE="http://vsftpd.devnet.ru/"
SRC_URI="http://vsftpd.devnet.ru/files/${PV%_p*}/ext.${PV#*_p}/vsFTPd-${PV%_p*}-ext${PV#*_p}.tgz"
S="${WORKDIR}/vsFTPd-${PV%_p*}-ext.${PV#*_p}"
MY_PN="vsftpd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="caps pam tcpd ssl selinux xinetd"

DEPEND="caps? ( >=sys-libs/libcap-2 )
	pam? ( virtual/pam )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? ( >=dev-libs/openssl-0.9.7d )"
RDEPEND="${DEPEND}
	!net-ftp/vsftpd
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )
	xinetd? ( sys-apps/xinetd )"

src_prepare() {

	# kerberos patch. bug #335980
	epatch "${FILESDIR}/${MY_PN}-3.0.2-kerberos.patch"

	# Patch the source, config and the manpage to use /etc/vsftpd/
	epatch "${FILESDIR}/${MY_PN}-3.0.2-gentoo.patch"

	# Fix building without the libcap
	epatch "${FILESDIR}/${MY_PN}-3.0.2-caps.patch"

	# Fix building on alpha. Bug #405829
	epatch "${FILESDIR}/${MY_PN}-3.0.2-alpha.patch"

	# Configure vsftpd build defaults
	use tcpd && echo "#define VSF_BUILD_TCPWRAPPERS" >> builddefs.h
	use ssl && echo "#define VSF_BUILD_SSL" >> builddefs.h
	use pam || echo "#undef VSF_BUILD_PAM" >> builddefs.h

	# Ensure that we don't link against libcap unless asked
	if ! use caps ; then
		sed -i '/^#define VSF_SYSDEP_HAVE_LIBCAP$/ d' sysdeputil.c || die
		epatch "${FILESDIR}"/${MY_PN}-3.0.2-dont-link-caps.patch
	fi

	# Let portage control stripping
	sed -i '/^LINK[[:space:]]*=[[:space:]]*/ s/-Wl,-s//' Makefile || die
	
	epatch "${FILESDIR}"/${MY_PN}-3.0.2-makefile.patch

	#Bug #450536
	epatch "${FILESDIR}"/${MY_PN}-3.0.2-remove-legacy-cap.patch
}

src_compile() {
	CFLAGS="${CFLAGS}" \
	CC="$(tc-getCC)" \
	emake
}

src_install() {
	into /usr
	doman ${MY_PN}.conf.5 ${MY_PN}.8
	dosbin ${MY_PN} || die "disbin failed"

	dodoc AUDIT BENCHMARKS BUGS Changelog FAQ \
		README README.security REWARD SIZE \
		SPEED TODO TUNING || die "dodoc failed"
	newdoc ${MY_PN}.conf ${MY_PN}.conf.example

	docinto security
	dodoc SECURITY/* || die "dodoc failed"

	insinto "/usr/share/doc/${PF}/examples"
	doins -r EXAMPLE/* || die "doins faileD"

	insinto /etc/${MY_PN}
	newins ${MY_PN}.conf{,.example}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" ${MY_PN}

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${MY_PN}.xinetd" ${MY_PN}
	fi

	newinitd "${FILESDIR}/${MY_PN}.init" ${MY_PN}

	keepdir /usr/share/${MY_PN}/empty

	exeinto /usr/libexec
	doexe "${FILESDIR}/vsftpd-checkconfig.sh"
	systemd_dounit "${FILESDIR}/${MY_PN}.service"
}

pkg_preinst() {
	# If we use xinetd, then we set listen=NO
	# so that our default config works under xinetd - fixes #78347
	if use xinetd ; then
		sed -i 's/listen=YES/listen=NO/g' "${D}"/etc/${MY_PN}/${MY_PN}.conf.example
	fi
}

pkg_postinst() {
	einfo "vsftpd init script can now be multiplexed."
	einfo "The default init script forces /etc/vsftpd/vsftpd.conf to exist."
	einfo "If you symlink the init script to another one, say vsftpd.foo"
	einfo "then that uses /etc/vsftpd/foo.conf instead."
	einfo
	einfo "Example:"
	einfo "   cd /etc/init.d"
	einfo "   ln -s vsftpd vsftpd.foo"
	einfo "You can now treat vsftpd.foo like any other service"
}
