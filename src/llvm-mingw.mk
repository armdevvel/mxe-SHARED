# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm-mingw
$(PKG)_WEBSITE  := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14
$(PKG)_CHECKSUM := d294d5435555150414fe6bc403d8b807a00611fbed5622d236719be2410128b8
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_URL      := https://github.com/armdevvel/llvm-mingw/releases/download/14.0/armv7-only-llvm-mingw-linux-x86_64.tar.xz

define $(PKG)_BUILD
	cp -r '$(1)'* '$(PREFIX)'
	mkdir -p '$(PREFIX)/lib/pkgconfig'
	mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
endef
