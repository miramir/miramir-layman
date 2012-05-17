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
KEYWORDS="~x86 ~amd64"
#IUSE="libevent mysql mariadb"
IUSE="mariadb mysql"
DEPEND="dev-libs/protobuf
	dev-libs/judy
	virtual/mysql
	app-portage/portage-utils" 
RDEPEND="${DEPEND}"
MYSQL_SRC_PATH=""
MYSQL_EBUILD_PATH=""

pkg_setup() {
	confutils_require_one mysql mariadb
	
	use mysql && {
		MYSQL_EBUILD_PATH=$(equery w dev-db/mysql)
		ver=$(echo $MYSQL_EBUILD_PATH | sed 's/.*mysql-\(.*\)\.ebuild/\1/')
		MYSQL_SRC_PATH="${PORTAGE_TMPDIR}/portage/dev-db/mysql-"$(echo $MYSQL_EBUILD_PATH | sed 's/.*mysql-\(.*\)\.ebuild/\1/')"/work/mysql"
	}
	
	use mariadb && {
		MYSQL_EBUILD_PATH=$(equery w dev-db/mariadb)
		MYSQL_SRC_PATH="${PORTAGE_TMPDIR}/portage/dev-db/mariadb-"$(echo $MYSQL_EBUILD_PATH | sed 's/.*-\(.*\)\.ebuild/\1/')"/work/mysql"
	}
}


src_configure() {
	ebuild $MYSQL_EBUILD_PATH compile
	myconf="--with-mysql=${MYSQL_SRC_PATH} --with-protobuf --with-judy --with-event"
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
