# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := babl
$(PKG)_WEBSITE  := https://gegl.org/babl/
$(PKG)_DESCR    := Pixel encoding and color space conversion engine in C 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.92
$(PKG)_CHECKSUM := f667735028944b6375ad18f160a64ceb93f5c7dccaa9d8751de359777488a2c1
$(PKG)_SUBDIR   := babl-$($(PKG)_VERSION)
$(PKG)_FILE     := babl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gimp.org/pub/babl/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt build
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef