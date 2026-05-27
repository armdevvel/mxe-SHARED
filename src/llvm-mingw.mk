# This file is part of MXE. See LICENSE.md for licensing information.

PKG                  := llvm-mingw
$(PKG)_WEBSITE       := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_VERSION       := 22.1.6
$(PKG)_CHECKSUM      := a288948b27e1c98c59924d7f1eb89eee737722cbf448e80cc36f34836b6f392b
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
