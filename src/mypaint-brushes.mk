# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mypaint-brushes
$(PKG)_WEBSITE  := https://github.com/mypaint/mypaint-brushes
$(PKG)_DESCR    := Brushes used by software using libmypaint. 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := fef66ffc241b7c5cd29e9c518e933c739618cb51c4ed4d745bf648a1afc3fe70
$(PKG)_SUBDIR   := mypaint-brushes-$($(PKG)_VERSION)
$(PKG)_FILE     := mypaint-brushes-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/mypaint/mypaint-brushes/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libmypaint

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef