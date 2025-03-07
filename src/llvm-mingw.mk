# This file is part of MXE. See LICENSE.md for licensing information.

PKG                  := llvm-mingw
$(PKG)_WEBSITE       := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_VERSION       := 14.0-debug-hotfix1
$(PKG)_CHECKSUM      := 195620dd64411ac86d1273b706c8b85fb81ad57d4028c2b00e9cf4e192f0603a
$(PKG)_FILE          := armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_URL           := https://github.com/armdevvel/llvm-mingw/releases/download/$($(PKG)_VERSION)/armv7-only-llvm-mingw-linux-x86_64.tar.xz
$(PKG)_TARGETS       := $(BUILD)
$(PKG)_DEPS          :=
$(PKG)_DEPS_$(BUILD) := snakeoil

define $(PKG)_BUILD_$(BUILD)
    cp -r '$(1)'* '$(PREFIX)'
    mkdir -p '$(PREFIX)/lib/pkgconfig'
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
endef
