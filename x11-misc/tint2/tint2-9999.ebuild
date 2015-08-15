# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/tint2/tint2-0.11-r1.ebuild,v 1.3 2011/04/25 13:52:51 tomka Exp $

EAPI="5"

inherit cmake-utils eutils gnome2-utils git-r3

DESCRIPTION="A lightweight panel/taskbar"
HOMEPAGE="https://gitlab.com/o9000/tint2/wikis/home"
EGIT_REPO_URI="https://gitlab.com/o9000/tint2.git"
#ESVN_PROJECT="tint2-read-only"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+battery examples tint2conf"

COMMON_DEPEND="dev-libs/glib:2
	x11-libs/cairo
	x11-libs/pango
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/libXrandr
	media-libs/imlib2[X]
	x11-libs/gtk+
	gnome-base/librsvg
	x11-libs/startup-notification"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
	x11-proto/xineramaproto"
RDEPEND="${COMMON_DEPEND}
	tint2conf? ( x11-misc/tintwizard )"

src_prepare() {
	epatch ${FILESDIR}/gtk-update-icon-cache.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable battery BATTERY)
		$(cmake-utils_use_enable examples EXAMPLES)
		$(cmake-utils_use_enable tint2conf TINT2CONF)

		# bug 296890
		"-DDOCDIR=/usr/share/doc/${PF}"
	)

	cmake-utils_src_configure
}



src_install() {
	cmake-utils_src_install
	rm -f "${D}/usr/bin/tintwizard.py"
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
