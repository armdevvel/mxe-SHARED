# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gegl
$(PKG)_WEBSITE  := https://gegl.org/
$(PKG)_DESCR    := Generic Graphics Library 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.36
$(PKG)_CHECKSUM := 6fd58a0cdcc7702258adaeffb573a389228ae8f0eff47578efda2309b61b2ca6
$(PKG)_SUBDIR   := gegl-$($(PKG)_VERSION)
$(PKG)_FILE     := gegl-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gimp.org/pub/gegl/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc babl json-glib

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt -Dpoppler=disabled -Dlibav=disabled build
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef