# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-unico/gtk-engines-unico-1.0.1.ebuild,v 1.3 2012/03/21 06:23:15 ssuominen Exp $

EAPI=4

MY_PN=${PN/gtk-engines-}
MY_PV=${PV/_p/+r}

echo "pn = ${MY_PN} pv = ${MY_PV}"

DESCRIPTION="Unico Gtk+ 3 theme engine"
HOMEPAGE="https://launchpad.net/unico"
SRC_URI="https://launchpad.net/unico/1.0/1.0.2/+download/unico-1.0.2.tar.gz"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/glib-2.26
	>=x11-libs/cairo-1.10[glib]
	>=x11-libs/gtk+-3.1.10:3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS NEWS" # ChangeLog, README are empty
}

src_configure() {
	# currently, the only effect of --enable-debug is to add -g to CFLAGS
	econf \
		--disable-debug \
		--disable-maintainer-flags \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f {} +
}
