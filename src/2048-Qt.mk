# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := 2048-Qt
$(PKG)_WEBSITE  := https://github.com/xiaoyong/$(PKG)
$(PKG)_DESCR    := A clone of 2048, implemented in Qt.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.5
$(PKG)_CHECKSUM := b895ecdbc09127215baf2633b513726cb39e24f22cc309ec390ac9bdae9b224c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc qtbase qtdeclarative qtquickcontrols

define $(PKG)_BUILD
    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
