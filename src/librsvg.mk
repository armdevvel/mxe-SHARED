# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librsvg
$(PKG)_WEBSITE  := https://librsvg.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.7
$(PKG)_CHECKSUM := 6ecb7ae2f75408f0c046166f327e50cefc57eb874e3c7ba43cd4daa10d5a0501
$(PKG)_SUBDIR   := librsvg-$($(PKG)_VERSION)
$(PKG)_FILE     := librsvg-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/librsvg/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cairo gdk-pixbuf glib libcroco libgsf pango

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.gnome.org/GNOME/librsvg/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_STATIC), \
          --disable-pixbuf-loader,) \
        --disable-gtk-doc \
        --enable-introspection=no \
        --disable-Bsymbolic
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -mwindows -W -Wall -Werror -Wno-error=deprecated-declarations \
        -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-librsvg.exe' \
        `'$(TARGET)-pkg-config' librsvg-2.0 --cflags --libs`
endef
