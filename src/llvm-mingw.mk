# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm-mingw
$(PKG)_WEBSITE  := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_VERSION  := 14.0-debug
$(PKG)_CHECKSUM := 47c3f14441d9475c25fff77d9c412cfe2c63204f0678741b42a01dbb3ad4f841
$(PKG)_FILE     := armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_URL      := https://github.com/armdevvel/llvm-mingw/releases/download/$($(PKG)_VERSION)/armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD_$(BUILD)
    cp -r '$(1)'* '$(PREFIX)'
    mkdir -p '$(PREFIX)/lib/pkgconfig'
    $(foreach TRIPLET,$(MXE_TRIPLETS),\
        $(mkdir -p '$(PREFIX)/$(TRIPLET)/lib/pkgconfig'))
endef