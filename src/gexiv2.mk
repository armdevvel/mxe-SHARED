# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gexiv2
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/gexiv2
$(PKG)_DESCR    := A GObject wrapper around the exiv2 photo metadata library 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.14.0
$(PKG)_CHECKSUM := e58279a6ff20b6f64fa499615da5e9b57cf65ba7850b72fafdf17221a9d6d69e
$(PKG)_SUBDIR   := gexiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := gexiv2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gexiv2/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc exiv2 glib

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --cross-file=cross.txt -Dintrospection=false -Dvapi=false -Dpython3=false --prefix '$(PREFIX)/$(TARGET)' build
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && ninja install
endef