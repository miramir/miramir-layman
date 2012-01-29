# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P=${P/_/\~}
DEBADDONS="${PN}2-${PV}/debian"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.xz
	mirror://gentoo/${MY_P}.tar.xz
	http://archive.ubuntu.com/ubuntu/pool/main/g/${PN}2/${PN}2_${PV}-14ubuntu2.diff.gz"
S=${WORKDIR}/${MY_P}

inherit mount-boot eutils flag-o-matic toolchain-funcs ${LIVE_ECLASS}
unset LIVE_ECLASS

DESCRIPTION="GNU GRUB boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="custom-cflags debug device-mapper efiemu nls static sdl truetype"

GRUB_PLATFORMS="coreboot efi-32 efi-64 emu ieee1275 multiboot pc qemu qemu-mips yeeloong"
# everywhere:
#     emu
# mips only:
#     qemu-mips, yeeloong
# amd64, x86, ppc, ppc64
#     ieee1275
# amd64, x86
#     coreboot, multiboot, efi-32, pc, qemu
# amd64
#     efi-64
for i in ${GRUB_PLATFORMS}; do
	IUSE+=" grub_platforms_${i}"
done
unset i

# os-prober: Used on runtime to detect other OSes
# xorriso (dev-libs/libisoburn): Used on runtime for mkrescue
RDEPEND="
	dev-libs/libisoburn
	dev-libs/lzo
	sys-boot/os-prober
	>=sys-libs/ncurses-5.2-r5
	debug? (
		sdl? ( media-libs/libsdl )
	)
	device-mapper? ( >=sys-fs/lvm2-2.02.45 )
	truetype? ( media-libs/freetype >=media-fonts/unifont-5 )"
DEPEND="${RDEPEND}
	>=dev-lang/python-2.5.2
	sys-devel/flex
	virtual/yacc
"
DEPEND+=" >=sys-devel/autogen-5.10 sys-apps/help2man"

export STRIP_MASK="*/grub*/*/*.{mod,img}"
QA_EXECSTACK="
	lib64/grub2/*/setjmp.mod
	lib64/grub2/*/kernel.img
	sbin/grub2-probe
	sbin/grub2-setup
	sbin/grub2-mkdevicemap
	bin/grub2-script-check
	bin/grub2-fstest
	bin/grub2-mklayout
	bin/grub2-menulst2cfg
	bin/grub2-mkrelpath
	bin/grub2-mkpasswd-pbkdf2
	bin/grub2-mkfont
	bin/grub2-editenv
	bin/grub2-mkimage
"

grub_run_phase() {
	local phase=$1
	local platform=$2
	[[ -z ${phase} || -z ${platform} ]] && die "${FUNCNAME} [phase] [platform]"

	[[ -d "${WORKDIR}/build-${platform}" ]] || \
		{ mkdir "${WORKDIR}/build-${platform}" || die ; }
	pushd "${WORKDIR}/build-${platform}" > /dev/null || die

	echo ">>> Running ${phase} for platform \"${platform}\""
	echo ">>> Working in: \"${WORKDIR}/build-${platform}\""

	grub_${phase} ${platform}

	popd > /dev/null || die
}

grub_src_configure() {
	local platform=$1
	local target

	[[ -z ${platform} ]] && die "${FUNCNAME} [platform]"

	# if we have no platform then --with-platform=guessed does not work
	[[ ${platform} == "guessed" ]] && platform=""

	# check if we have to specify the target (EFI)
	# or just append correct --with-platform
	if [[ -n ${platform} ]]; then
		if [[ ${platform} == efi* ]]; then
			# EFI platform hack
			[[ ${platform/*-} == 32 ]] && target=i386
			[[ ${platform/*-} == 64 ]] && target=x86_64
			# program-prefix is required empty because otherwise it is equal to
			# target variable, which we do not want at all
			platform="
				--with-platform=${platform/-*}
				--target=${target}
				--program-prefix=
			"
		else
			platform=" --with-platform=${platform}"
		fi
	fi

	ECONF_SOURCE="${WORKDIR}/${P}/" \
	econf \
		--disable-werror \
		--sbindir=/sbin \
		--bindir=/bin \
		--libdir=/$(get_libdir) \
		--program-transform-name=s,grub,grub2, \
		$(use_enable debug mm-debug) \
		$(use_enable debug grub-emu-usb) \
		$(use_enable device-mapper) \
		$(use_enable efiemu) \
		$(use_enable nls) \
		$(use_enable truetype grub-mkfont) \
		$(use sdl && use_enable debug grub-emu-sdl) \
		${platform}
}

grub_src_compile() {
	default_src_compile
}

grub_src_install() {
	default_src_install
}

src_prepare() {
	local i j archs

	EPATCH_SOURCE="${WORKDIR}/" EPATCH_SUFFIX="diff" EPATCH_FORCE="yes" epatch
	for patch in $(cat "${S}/${DEBADDONS}/patches/series")
	do
		epatch "${S}/${DEBADDONS}/patches/${patch}"
	done

	epatch \
		"${FILESDIR}/1.99-call_proper_grub_probe.patch" \
		"${FILESDIR}/1.99-stat_root_device_properly-p1.patch" \
		"${FILESDIR}/1.99-stat_root_device_properly-p2.patch"

	epatch_user

	# autogen.sh does more than just run autotools
	(. ./autogen.sh) || die

	# install into the right dir for eselect #372735
	sed -i \
		-e '/^bashcompletiondir =/s:=.*:= $(datarootdir)/bash-completion:' \
		util/bash-completion.d/Makefile.in || die

	# get enabled platforms
	GRUB_ENABLED_PLATFORMS=""
	for i in ${GRUB_PLATFORMS}; do
		use grub_platforms_${i} && GRUB_ENABLED_PLATFORMS+=" ${i}"
	done
	[[ -z ${GRUB_ENABLED_PLATFORMS} ]] && GRUB_ENABLED_PLATFORMS="guessed"
	einfo "Going to build following platforms: ${GRUB_ENABLED_PLATFORMS}"
}

src_configure() {
	local i

	use custom-cflags || unset CFLAGS CPPFLAGS LDFLAGS
	use static && append-ldflags -static

	for i in ${GRUB_ENABLED_PLATFORMS}; do
		grub_run_phase ${FUNCNAME} ${i}
	done
}

src_compile() {
	local i

	for i in ${GRUB_ENABLED_PLATFORMS}; do
		grub_run_phase ${FUNCNAME} ${i}
	done
}

src_install() {
	local i

	for i in ${GRUB_ENABLED_PLATFORMS}; do
		grub_run_phase ${FUNCNAME} ${i}
	done

	# slot all collisions with grub legacy
	mv "${ED}"/usr/share/info/grub.info \
		"${ED}"/usr/share/info/grub2.info || die

	# can't be in docs array as we use defualt_src_install in different builddir
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
	insinto /etc/default
	newins "${FILESDIR}"/grub.default grub
	cat <<EOF >> "${ED}"/lib*/grub2/grub-mkconfig_lib
	GRUB_DISTRIBUTOR="Gentoo"
EOF
}

setup_boot_dir() {
	local dir=$1

	# display the link to guide if user didn't set up anything yet.
	elog "For informations how to configure grub-2 please reffer to the guide:"
	elog "    http://dev.gentoo.org/~scarabeus/grub-2-guide.xml"

	if [[ ! -e ${dir}/grub.cfg && -e ${dir/2/}/menu.lst ]] ; then
		# This is first grub2 install and we have old configuraton for
		# grub1 around. Lets try to generate grub.cfg from it so user
		# does not loose any stuff when rebooting.
		# NOTE: in long term he still NEEDS to migrate to grub.d stuff.
		einfo "Running: grub2-menulst2cfg '${dir/2/}/menu.lst' '${dir}/grub.cfg'"
		grub2-menulst2cfg "${dir/2/}/menu.lst" "${dir}/grub.cfg" || \
			ewarn "Running grub2-menulst2cfg failed!"

		einfo "Even if we just created configuration for your grub2 using old"
		einfo "grub-legacy configuration file you should migrate to use new style"
		einfo "configuration in '${ROOT}/etc/grub.d'."
		einfo

	else
		# we need to refresh the grub.cfg everytime just to play it safe
		einfo "Running: grub2-mkconfig -o '${dir}/grub.cfg'"
		grub2-mkconfig -o "${dir}/grub.cfg" || \
			ewarn "Running grub2-mkconfig failed! Check your configuration files!"
	fi

	elog "Remember to run \"grub2-mkconfig -o '${dir}/grub.cfg'\" every time"
	elog "you update the configuration files!"

	elog "Remember to run grub2-install to install your grub every time"
	elog "you update this package!"
}

pkg_postinst() {
	mount-boot_mount_boot_partition

	setup_boot_dir "${ROOT}"boot/grub2

	# needs to be called after we call setup_boot_dir
	mount-boot_pkg_postinst
}
