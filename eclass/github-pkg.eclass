# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: github-pkg.eclass
# @MAINTAINER:
# Anthony Parsons <ant+gentoo.bugs@flussence.eu>
# @AUTHOR:
# Anthony Parsons <ant+gentoo.bugs@flussence.eu>
# @BLURB: Common code for GitHub-hosted packages
# @DESCRIPTION:
# The github-pkg eclass fills in git-r3 related variables with sensible defaults.
# By default, HOMEPAGE is set to the repo URL and EGIT_REPO_URI is derived from it.
# Upstreams tend to use wildly inconsistent tarball naming conventions, so no SRC_URI is provided.
# @SUPPORTED_EAPIS: 6 7

# @ECLASS-VARIABLE: GITHUB_USER
# @REQUIRED
# @DESCRIPTION:
# Specify the owner name in the repository's URL.

# @ECLASS-VARIABLE: GITHUB_PROJ
# @DEFAULT_UNSET
# @DESCRIPTION:
# Specify the project name in the repository's URL; defaults to PN.

case ${EAPI:-0} in
	6|7)
		GITHUB_HOMEPAGE="https://github.com/${GITHUB_USER:?}/${GITHUB_PROJ:-${PN}}"
		: ${KEYWORDS:?"Must be defined before inheriting github-pkg.eclass"}
		: ${HOMEPAGE:=$GITHUB_HOMEPAGE}

		if [[ ${PV} == "9999" ]]; then
			: ${EGIT_REPO_URI:=${HOMEPAGE}.git}
			inherit git-r3
			KEYWORDS=""
		fi
		;;
	*)
		die "EAPI ${EAPI} is not supported by github-pkg.eclass"
		;;
esac
