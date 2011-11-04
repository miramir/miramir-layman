
EAPI=3
PYTHON_DEPEND="2:2.5"

inherit distutils

DESCRIPTION="a note taking application"
HOMEPAGE="http://keepnote.org/keepnote/"
SRC_URI="http://keepnote.org/keepnote/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="spell"

DEPEND=">=dev-python/pygtk-2.12.0
       spell? ( >=app-text/gtkspell-2.0.11-r1 )"
RDEPEND="${DEPEND}"

DOCS="CHANGES README"

