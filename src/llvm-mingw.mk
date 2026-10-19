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

    # Release
    mkdir -p '$(PREFIX)/armv7-w64-mingw32/lib/pkgconfig'
    mkdir -p '$(PREFIX)/armv7-w64-mingw32/include/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32/include/GL' '$(PREFIX)/armv7-w64-mingw32/include/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32/include/KHR' '$(PREFIX)/armv7-w64-mingw32/include/BASEGL'
    mkdir -p '$(PREFIX)/armv7-w64-mingw32/lib/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32/lib/libglu32.a' '$(PREFIX)/armv7-w64-mingw32/lib/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32/lib/libopengl32.a' '$(PREFIX)/armv7-w64-mingw32/lib/BASEGL'

    # Debug
    mkdir -p '$(PREFIX)/armv7-w64-mingw32.debug/lib/pkgconfig'
    mkdir -p '$(PREFIX)/armv7-w64-mingw32.debug/include/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32.debug/include/GL' '$(PREFIX)/armv7-w64-mingw32.debug/include/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32.debug/include/KHR' '$(PREFIX)/armv7-w64-mingw32.debug/include/BASEGL'
    mkdir -p '$(PREFIX)/armv7-w64-mingw32.debug/lib/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32.debug/lib/libglu32.a' '$(PREFIX)/armv7-w64-mingw32.debug/lib/BASEGL'
    mv '$(PREFIX)/armv7-w64-mingw32.debug/lib/libopengl32.a' '$(PREFIX)/armv7-w64-mingw32.debug/lib/BASEGL'
endef
