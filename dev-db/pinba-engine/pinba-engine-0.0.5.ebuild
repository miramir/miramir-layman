# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools confutils eutils multilib
DESCRIPTION="Pinba engine"
HOMEPAGE="http://pinba.org/wiki/Main_Page"
SRC_URI="http://pinba.org/files/pinba_engine-${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86"
#IUSE="libevent mysql mariadb"
IUSE=""
DEPEND="dev-libs/protobuf
	dev-libs/judy
	virtual/mysql" 
DISTDIR="/usr/portage/distfiles/"
RDEPEND="${DEPEND}"

pkg_setup() {
#	confutils_require_one mysql mariadb
	ebuild /usr/portage/dev-db/mysql/mysql-5.1.50-r1.ebuild compile
	#mv /var/tmp/portage/dev-db/mysql-5.1.52/work 
}


src_configure() {
	ebuild /
	local
	myconf="--with-mysql=/var/tmp/portage/dev-db/mysql-5.1.50-r1/work/mysql/
	--with-protobuf --with-judy --with-event"
	myconf="${myconf} --libdir=/usr/$(get_libdir)/mysql/plugin"
	cd "pinba_engine-${PV}"
	#use libevent && myconf="${myconf} --with-event"
	econf ${myconf}
}
src_install() {
	cd pinba_engine-${PV}
	emake install DESTDIR="${D}" || die "emake install failed"
	dodir /usr/share/pinba/
	insinto /usr/share/pinba/
	doins default_tables.sql
}

pkg_postinst() {
	einfo "You need to execute the following command on mysql server"
	einfo "so pinba works properly:"
	elog "mysql> INSTALL PLUGIN pinba SONAME 'libpinba_engine.so';"
	elog "mysql> CREATE DATABASE pinba;"
	elog "mysql -D pinba < /usr/share/pinba/default_tables.sql"
}
