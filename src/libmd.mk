# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmd
$(PKG)_WEBSITE  := https://www.hadrons.org/software/libmd
$(PKG)_DESCR    := Message Digest functions from BSD systems
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.4
$(PKG)_CHECKSUM := f51c921042e34beddeded4b75557656559cf5b1f2448033b4c1eec11c07e530f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://archive.hadrons.org/software/$(PKG)/$($(PKG)_FILE)

$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd $(1) \
        && autoreconf -fi -I $(PREFIX)/$(TARGET)/share/aclocal \
        && automake --add-missing \
        && ./configure \
            $(MXE_CONFIGURE_OPTS) \
        && $(MAKE) \
            -j '$(JOBS)' \
            install
endef
