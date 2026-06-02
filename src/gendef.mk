# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gendef
$(PKG)_WEBSITE  := https://sourceforge.net/p/mingw-w64/wiki2/gendef/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.0.0
$(PKG)_CHECKSUM := 6eaf921d9eb987d3820b364ea9775bc19b965ec81490b6fdd716526c28e1995c
$(PKG)_SUBDIR   := mingw-w64-v$($(PKG)_VERSION)
$(PKG)_FILE     := mingw-w64-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    cd '$(1)/mingw-w64-tools/gendef' && ./configure \
        CFLAGS='-Wno-implicit-fallthrough' \
        --host='$(BUILD)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target='$(TARGET)'
    $(MAKE) -C '$(1)/mingw-w64-tools/gendef' -j '$(JOBS)' install
endef
