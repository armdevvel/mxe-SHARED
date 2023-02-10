# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wine
$(PKG)_WEBSITE  := https://www.winehq.org/
$(PKG)_DESCR    := Wine Is Not an Emulator
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0
$(PKG)_CHECKSUM := 0272c20938f8721ae4510afaa8b36037457dd57661e4d664231079b9e91c792e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://dl.winehq.org/$(PKG)/source/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_TYPE     := source-only

$(PKG)_DESTDIR  := $(PREFIX)/$(PKG)
$(PKG)_TOOLDIR  := $($(PKG)_DESTDIR)/bin
$(PKG)_NLS_DIR  := $($(PKG)_DESTDIR)/share/wine/nls
