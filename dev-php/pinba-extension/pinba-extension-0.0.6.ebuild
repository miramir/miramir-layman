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


S="${WORKDIR}/pinba_extension-${PV}"

