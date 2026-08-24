# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gtksourceview3
$(PKG)_WEBSITE  := https://projects.gnome.org/gtksourceview/
$(PKG)_DESCR    := GTKSourceView 3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.24.9
$(PKG)_CHECKSUM := 699d76a453e6a3d3331906346e3dbfa25f2cbc9ec090e46635e9c6bb595e07c2
$(PKG)_SUBDIR   := gtksourceview-$($(PKG)_VERSION)
$(PKG)_FILE     := gtksourceview-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/gtksourceview/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtk3 libxml2

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-static \
        --enable-shared \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' CFLAGS="-Wno-incompatible-pointer-types"
    $(MAKE) -C '$(1)' -j 1 install
endef
