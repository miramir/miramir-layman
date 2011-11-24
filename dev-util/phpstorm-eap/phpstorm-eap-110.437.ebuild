# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.0.1.152.ebuild,v 1.2 2011/10/05 12:32:41 scarabeus Exp $

EAPI=4
inherit eutils

DESCRIPTION="PhpStorm IDE EAP"
SRC_URI="http://download.jetbrains.com/webide/PhpStorm-EAP-${PV}.tar.gz"
HOMEPAGE="http://www.jetbrains.com/phpstorm/"
SLOT="0"

KEYWORDS="~amd64 ~x86"
RESTRICT="strip mirror"

S="${WORKDIR}"

DEPEND=">=virtual/jre-1.6"

# Where should this all go? (Bug #328639)
INSTALL_BASE="/opt/phpstorm-eap"

# Ignore QA warnings in these closed-source binaries, since we can't fix them:
#QA_PREBUILT="opt/*"

src_install() {
	echo "--- ${FILESDIR}/phpstorm.desktop ---"
	domenu "${FILESDIR}/phpstorm.desktop" || die
	insinto /usr/share/icons/hicolor/128x128/apps
	newins "PhpStorm-${PV}/bin/webide.png" phpstorm.png

	insinto ${INSTALL_BASE}
	doins -r PhpStorm-${PV}/* || die
	fperms a+rx ${INSTALL_BASE}/bin/fsnotifier
	fperms a+rx ${INSTALL_BASE}/bin/fsnotifier64
	fperms a+rx ${INSTALL_BASE}/bin/phpstorm.sh

	dodir /opt/bin
	dosym ${INSTALL_BASE}/bin/phpstorm.sh /opt/bin/phpstorm

}

