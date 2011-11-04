# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_EXT_NAME="xhprof"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

WEBAPP_MANUAL_SLOT=yes

EAPI=2
inherit webapp

KEYWORDS="~amd64 ~x86"

HOMEPAGE="http://pecl.php.net/package/xhprof"
DESCRIPTION="The web-ui of xhprof."
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

SRC_URI="http://pecl.php.net/get/${PN/-ui/}-${PV}.tgz"

DEPEND="media-gfx/graphviz"
RDEPEND="${DEPEND}
dev-lang/php
"

S="${WORKDIR}/${PN/-ui/}-${PV}"

src_install() {
	webapp_src_preinst
	mkdir -p "${D}/usr/share/webapps/${PN}/${PVR}/"
	mkdir -p "${D}/usr/share/php/xhprof"
	mv xhprof_html/* "${D}/${MY_HTDOCSDIR}/"
	mv xhprof_lib "$D/usr/share/php/xhprof"
	webapp_src_install
}
