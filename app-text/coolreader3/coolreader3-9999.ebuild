# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://crengine.git.sourceforge.net/gitroot/crengine/crengine"

inherit cmake-utils git

HYP_ARCH="AlReader2.Hyphen.zip"

DESCRIPTION="CoolReader - reader of eBook files (fb2,epub,htm,rtf,txt)"
HOMEPAGE="http://www.coolreader.org/"
SRC_URI=""

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 +wxwidgets hyphen"

RDEPEND="media-fonts/corefonts"
DEPEND="sys-libs/zlib
 	media-libs/libpng
 	media-libs/jpeg
 	media-libs/freetype
 	wxwidgets? ( >=x11-libs/wxGTK-2.8 )
 	qt4? ( x11-libs/qt-core:4
 		x11-libs/qt-gui:4 )
 	hyphen? ( app-arch/unzip )"

src_unpack() {
	git_src_unpack
	if 	use hyphen; then
		unpack ${HYP_ARCH}
	fi
	mkdir ${S}
	cd "${S}" || die "failed to cd to build dir"
	# fix for amd64
	if use amd64; then
		sed -e 's/unsigned int/unsigned long/g' -i "${WORKDIR}/${P}/crengine/src/lvdocview.cpp" \
		|| die "patching lvdocview.cpp for amd64 failed"
	fi
}

src_configure() {
	CMAKE_USE_DIR="${WORKDIR}"/"${SRC_UNPACK}"/"${P}"
	CMAKE_BUILD_TYPE="Release"
	if use qt4 && ! use wxwidgets; then
		mycmakeargs="-D GUI=QT"
	elif use wxwidgets && ! use qt4; then
		. "${ROOT}/var/lib/wxwidgets/current"
            if [[ "${WXCONFIG}" -eq "none" ]]; then
                	die "The wxGTK profile should be selected!"
        	fi
        	mycmakeargs="-D GUI=WX"
	else
		die "Only one GUI must be selected"
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use hyphen; then
		cd ${WORKDIR}
		insinto /usr/share/crengine
		find . -name "*hyphen*pdb" -exec \
			doins {} \;
	fi
	dosym ../fonts/corefonts /usr/share/crengine/fonts
	dodoc "${FILESDIR}/README"
}
