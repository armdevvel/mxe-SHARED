# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := https://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3400100
$(PKG)_CHECKSUM := 2c5dea207fa508d765af1ef620b637dcb06572afa6f01f0815bd5bbf864b33d9
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.sqlite.org/2022/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-readline \
        --enable-threadsafe

    # For some reason, using CFLAGS with --enable-debug BREAKS the library?
    # It seems it gets ignored, so just using it with make instead sufices.
    # TODO: Make sqlite not strip the executable during installation
    $(MAKE) -C '$(1)' -j 1 CFLAGS="-DSQLITE_ENABLE_COLUMN_METADATA" install
endef
