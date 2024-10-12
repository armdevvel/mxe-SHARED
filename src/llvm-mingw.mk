# This file is part of MXE. See LICENSE.md for licensing information.

PKG                  := llvm-mingw
$(PKG)_WEBSITE       := http://www.github.com/mstorsjo/llvm-mingw
$(PKG)_VERSION       := 14.0-debug
$(PKG)_CHECKSUM      := 26ecd6515c54840a5cad16f02fe3d3f5f2b37028d2685e33068c9a893e555f0d
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
