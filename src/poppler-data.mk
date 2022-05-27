# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poppler-data
$(PKG)_WEBSITE  := https://poppler.freedesktop.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.11
$(PKG)_CHECKSUM := 2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c
$(PKG)_SUBDIR   := poppler-data-$($(PKG)_VERSION)
$(PKG)_FILE     := poppler-data-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://poppler.freedesktop.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc poppler

define $(PKG)_BUILD
    # build and install the library
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' prefix='$(PREFIX)/$(TARGET)' install
endef
