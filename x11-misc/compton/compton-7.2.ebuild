# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="yshui"
KEYWORDS="~amd64 ~x86"

inherit desktop github-pkg meson xdg

DESCRIPTION="Compton is a X compositing window manager, fork of xcompmgr-dana."

if [[ ${PV} != "9999" ]]; then
	MY_PV="${PV/_rc/-rc}"
	TEST_H_COMMIT="a84877df68873f80ff3620f4993619b35b21f758"
	SRC_URI="${HOMEPAGE}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${HOMEPAGE/${PN}/test.h}/archive/${TEST_H_COMMIT}.tar.gz
			-> yshui_test.h_${TEST_H_COMMIT}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MPL-2.0 MIT"
SLOT="0"
IUSE="dbus drm +doc +libconfig +opengl +pcre"

RDEPEND="
	dev-libs/libev
	>=x11-libs/libxcb-1.9.2
	x11-libs/libXext
	x11-libs/libXdamage
	x11-libs/libXrender
	x11-libs/libXrandr
	x11-libs/libXcomposite
	x11-libs/pixman
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-renderutil
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm )
	libconfig? (
		>=dev-libs/libconfig-1.4:=
		dev-libs/libxdg-basedir
	)
	opengl? ( virtual/opengl )
	pcre? ( >=dev-libs/libpcre-8.20:3 )"
DEPEND="${RDEPEND}
	dev-libs/uthash"
BDEPEND="doc? ( app-text/asciidoc )"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		# compton-7-rc1.tar.gz is broken, so patch in the missing git submodule by hand
		default
		cd "${S}/subprojects" || die
		rmdir test.h || die
		ln -rs "../../test.h-${TEST_H_COMMIT}" test.h || die
	fi
}

src_configure() {
	# TODO: support FEATURES=test properly
	local emesonargs=(
		"$(meson_use dbus)"
		"$(meson_use doc with_docs)"
		"$(meson_use drm vsync_drm)"
		"$(meson_use libconfig config_file)"
		"$(meson_use opengl)"
		"$(meson_use pcre regex)"
	)
	meson_src_configure
}

src_install() {
	dodoc CONTRIBUTORS

	docinto examples
	dodoc compton-*-fshader-win.glsl compton.sample.conf
	if use dbus; then
		dodoc -r dbus-examples/
	fi

	meson_src_install
}
