# Copyright 1999-2020 Go Overlay Authors
# Distributed under the terms of the GNU General Public License v2
# shellcheck disable=SC2034
#

EAPI=8
inherit go-module
EGO_SUM=(
    "github.com/davecgh/go-spew v1.1.0"
    "github.com/davecgh/go-spew v1.1.0/go.mod"
    "github.com/go-ole/go-ole v1.2.6"
    "github.com/go-ole/go-ole v1.2.6/go.mod"
    "github.com/google/go-cmp v0.5.6/go.mod"
    "github.com/google/go-cmp v0.5.7"
    "github.com/google/go-cmp v0.5.7/go.mod"
    "github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0"
    "github.com/lufia/plan9stats v0.0.0-20211012122336-39d0f177ccd0/go.mod"
    "github.com/mattn/go-runewidth v0.0.9"
    "github.com/mattn/go-runewidth v0.0.9/go.mod"
    "github.com/pmezard/go-difflib v1.0.0"
    "github.com/pmezard/go-difflib v1.0.0/go.mod"
    "github.com/power-devops/perfstat v0.0.0-20210106213030-5aafc221ea8c"
    "github.com/power-devops/perfstat v0.0.0-20210106213030-5aafc221ea8c/go.mod"
    "github.com/shirou/gopsutil/v3 v3.22.3"
    "github.com/shirou/gopsutil/v3 v3.22.3/go.mod"
    "github.com/stretchr/objx v0.1.0/go.mod"
    "github.com/stretchr/testify v1.7.1"
    "github.com/stretchr/testify v1.7.1/go.mod"
    "github.com/tklauser/go-sysconf v0.3.10"
    "github.com/tklauser/go-sysconf v0.3.10/go.mod"
    "github.com/tklauser/numcpus v0.4.0"
    "github.com/tklauser/numcpus v0.4.0/go.mod"
    "github.com/yuin/goldmark v1.4.13/go.mod"
    "github.com/yusufpapurcu/wmi v1.2.2"
    "github.com/yusufpapurcu/wmi v1.2.2/go.mod"
    "golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
    "golang.org/x/crypto v0.0.0-20210921155107-089bfa567519/go.mod"
    "golang.org/x/mod v0.6.0-dev.0.20220419223038-86c51ed26bb4/go.mod"
    "golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
    "golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
    "golang.org/x/net v0.0.0-20220722155237-a158d28d115b/go.mod"
    "golang.org/x/sync v0.0.0-20190423024810-112230192c58/go.mod"
    "golang.org/x/sync v0.0.0-20220722155255-886fb9371eb4/go.mod"
    "golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
    "golang.org/x/sys v0.0.0-20190916202348-b4ddaad3f8a3/go.mod"
    "golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
    "golang.org/x/sys v0.0.0-20201204225414-ed752295db88/go.mod"
    "golang.org/x/sys v0.0.0-20210615035016-665e8c7367d1/go.mod"
    "golang.org/x/sys v0.0.0-20220128215802-99c3d69c2c27/go.mod"
    "golang.org/x/sys v0.0.0-20220520151302-bc2c85ada10a/go.mod"
    "golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f"
    "golang.org/x/sys v0.0.0-20220722155257-8c9f86f7a55f/go.mod"
    "golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
    "golang.org/x/term v0.0.0-20210927222741-03fcf44c2211"
    "golang.org/x/term v0.0.0-20210927222741-03fcf44c2211/go.mod"
    "golang.org/x/text v0.3.0/go.mod"
    "golang.org/x/text v0.3.3/go.mod"
    "golang.org/x/text v0.3.7/go.mod"
    "golang.org/x/text v0.3.8"
    "golang.org/x/text v0.3.8/go.mod"
    "golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
    "golang.org/x/tools v0.0.0-20191119224855-298f0cb1881e/go.mod"
    "golang.org/x/tools v0.1.12/go.mod"
    "golang.org/x/xerrors v0.0.0-20190717185122-a985d3407aa7/go.mod"
    "golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543"
    "golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
    "gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
    "gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
    "gopkg.in/ini.v1 v1.66.4"
    "gopkg.in/ini.v1 v1.66.4/go.mod"
    "gopkg.in/yaml.v2 v2.4.0"
    "gopkg.in/yaml.v2 v2.4.0/go.mod"
    "gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
    "gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="A beautiful and useful low-latency prompt for your shell"
HOMEPAGE="https://github.com/justjanne/powerline-go"
SRC_URI="
	https://github.com/justjanne/powerline-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"

src_compile() {
	ego build
}

src_install() {
	dobin "${PN}"
}
