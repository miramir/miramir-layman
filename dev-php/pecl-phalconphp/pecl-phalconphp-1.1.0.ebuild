# Copyright 2012 Victor Guardiola <victor.guardiola@gmail.com>
# Distributed under the terms of the GNU General Public License v2

EAPI=4
PHP_EXT_NAME="phalcon"
PHP_EXT_PECL_PKG="phalcon"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=""
PHP_EXT_INIFILE="phalcon.ini"
USE_PHP="php5-3 php5-4"
inherit php-ext-pecl-r2 git-2
SRC_URI=""
EGIT_REPO_URI="git://github.com/phalcon/cphalcon.git"
EGIT_BRANCH="1.1.0"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="http://www.phalconphp.com"
DESCRIPTION="Phalcon PHP is a web framework delivered as a C extension providing high performance and lower resource consumption"
LICENSE="BSD"
SLOT="0"
DEPEND=">=dev-php/PEAR-PEAR-1.9.1
		dev-lang/php[mysqli,unicode,crypt,ssl,pdo]"
RDEPEND="${DEPEND}"
FIX_S="${WORKDIR}/${PHP_EXT_NAME}-${PV}/build/"
FIx_ARCH=`uname -m`; 
if [[ $FIX_ARCH -eq "x86_64" ]] ; then FIX_ARCH='64bits';else FIX_ARCH='32bits';fi;
FIX_S="${WORKDIR}/${PHP_EXT_NAME}-${PV}/build/${FIX_ARCH}/"
src_prepare () {
    cd ${WORKDIR}/
	mkdir php5.{3,4}
	cp -r ${FIX_S}/* php5.3/
	cp -r ${FIX_S}/* php5.4/
    php-ext-source-r2_src_prepare
}
src_configure() {
	my_conf="--enable-phalcon"
	php-ext-source-r2_src_configure
}
src_compile () {
    php-ext-source-r2_src_compile
}
src_install () {
    php-ext-source-r2_src_install
}
