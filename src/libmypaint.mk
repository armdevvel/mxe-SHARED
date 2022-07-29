# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmypaint
$(PKG)_WEBSITE  := https://github.com/mypaint/libmypaint
$(PKG)_DESCR    := A library for making brushstrokes used in painting projects
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.0
$(PKG)_CHECKSUM := a5ec3624ba469b7b35fd66b6fbee7f07285b7a7813d02291ac9b10e46618140e
$(PKG)_SUBDIR   := libmypaint-$($(PKG)_VERSION)
$(PKG)_FILE     := libmypaint-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/mypaint/libmypaint/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc json-c glib

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-introspection \
        --enable-gegl
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS="-lintl -no-undefined"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef