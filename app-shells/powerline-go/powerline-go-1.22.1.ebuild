# Copyright 1999-2020 Go Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GOLANG_PKG_IMPORTPATH="github.com/justjanne"
GOLANG_PKG_ARCHIVEPREFIX="v"

GOLANG_PKG_DEPENDENCIES=(
	"github.com/mattn/go-runewidth:14e809f" #v0.0.9
	"github.com/shirou/gopsutil:cf63093" #v3.22.3
	"github.com/golang/sys:99c3d69c2c27 -> golang.org/x"
	"github.com/golang/term:f5c789dd3221 -> golang.org/x"
	"github.com/golang/text:22f1617 -> golang.org/x" # v0.3.4
	"github.com/go-ini/ini:39f9e49 -> gopkg.in/ini.v1" #v1.66.4
	"github.com/go-yaml/yaml:7649d45 -> gopkg.in/yaml.v2" # v2.4.0
	"github.com/tklauser/go-sysconf:0dc6a3a"
	"github.com/tklauser/numcpus:d68c580"
)

inherit golang-single

DESCRIPTION="A beautiful and useful low-latency prompt for your shell"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 arm"
