# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}/zmq-${PV}"

PHP_EXT_NAME="zmq"
USE_PHP="php5-4 php5-5 php5-6"

inherit php-ext-source-r2

DESCRIPTION="PHP extension for 0MQ messaging system"
HOMEPAGE="http://www.zeromq.org/bindings:php"
SRC_URI="http://pecl.php.net/get/zmq-${PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=net-libs/zeromq-2.1.0"
