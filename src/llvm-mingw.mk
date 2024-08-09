# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm-mingw
$(PKG)_WEBSITE  := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_VERSION  := 18.0
$(PKG)_CHECKSUM := 393abf26e25bcf03a923310389f874fc0a3134619a54eedb5e84c5ff43cbd664
$(PKG)_FILE     := armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_URL      := https://github.com/armdevvel/llvm-mingw/releases/download/$($(PKG)_VERSION)/armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_DEPS     := $(BUILD)~snakeoil

define $(PKG)_BUILD
    cp -r '$(1)'* '$(PREFIX)'
    mkdir -p '$(PREFIX)/lib/pkgconfig'
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
endef
