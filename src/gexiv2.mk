# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gexiv2
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/gexiv2
$(PKG)_DESCR    := A GObject wrapper around the exiv2 photo metadata library 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.9
$(PKG)_CHECKSUM := 8806234aa6fd1c345d46bf07a14e82771415071ca5ff63615b1ea62bd2fec0ed
$(PKG)_SUBDIR   := gexiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := gexiv2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gexiv2/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc exiv2 glib

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt build
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef