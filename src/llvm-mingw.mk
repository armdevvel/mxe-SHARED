# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm-mingw
$(PKG)_WEBSITE  := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.0-opengl
$(PKG)_CHECKSUM := a9d040c08dded13d3d3d5f958cc1bda2060c415b40ca4d719a78efaa6e82f272
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_URL      := https://github.com/armdevvel/llvm-mingw/releases/download/$($(PKG)_VERSION)/armv7-only-llvm-mingw-linux-x86_64.tar.xz

define $(PKG)_BUILD
	cp -r '$(1)'* '$(PREFIX)'
	mkdir -p '$(PREFIX)/lib/pkgconfig'
	mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
endef
