# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Pinba PHP extension"
HOMEPAGE="http://pinba.org"
SRC_URI="http://pinba.org/files/pinba_extension-${PV}.tgz"

PHP_EXT_NAME="pinba"
PHP_EXT_INI="no"
PHP_EXT_ZENDEXT="no"
inherit autotools eutils php-ext-source-r2

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DISTDIR="/usr/portage/distfiles/"
DEPEND="dev-lang/php
	dev-util/re2c
	dev-libs/protobuf"
RDEPEND="${DEPEND}"


#rc_configure() {
#cd pinba-${PV}	
#phpize
	#eautoconf
	#eaclocal
	#utoreconf
#
S="${WORKDIR}/pinba_extension-${PV}"
#src_unpack() {
#	PN="pinba_extension"
#}
src_prepare() {
	php-ext-source-r2_src_prepare
}
src_configure() {
	php-ext-source-r2_src_configure
}
#need_php_by_category
src_install() {
	php-ext-source-r2_src_install
	dodoc NEWS README CREDITS
#	dodir "${PHP_EXT_SHARED_DIR}"

#insinto "${PHP_EXT_SHARED_DIR}"
#	doins pinba.php

	#einstall
	#php-lib-r1_src_install ./ 
}
