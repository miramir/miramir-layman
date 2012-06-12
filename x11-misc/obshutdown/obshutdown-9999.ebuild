# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/strace/strace-9999.ebuild,v 1.2 2012/05/02 21:59:12 vapier Exp $

EAPI="4"

inherit flag-o-matic eutils git-2 autotools

EGIT_REPO_URI="git://github.com/panjandrum/obshutdown.git"

DESCRIPTION="GTK/Cairo based shutdown box styled for Openbox and others windows managers"
HOMEPAGE="https://github.com/panjandrum/obshutdown"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL"
SLOT="0"

# strace only uses the header from libaio to decode structs
DEPEND=">=x11-libs/gtk+-2.24.10-r1
	>=x11-libs/cairo-1.10.2"
RDEPEND=""

