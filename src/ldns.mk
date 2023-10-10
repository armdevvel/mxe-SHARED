# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ldns
$(PKG)_WEBSITE  := https://nlnetlabs.nl/$(PKG)
$(PKG)_DESCR    := LDNS is a DNS library that facilitates DNS tool programming
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3
$(PKG)_CHECKSUM := c3f72dd1036b2907e3a56e6acf9dfb2e551256b3c1bbd9787942deeeb70e7860
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://www.nlnetlabs.nl/downloads/$(PKG)/$($(PKG)_SUBDIR).tar.gz
$(PKG)_DEPS     := cc openssl ws2fwd

define $(PKG)_BUILD
    ln -sf '../ldns/config.h' '$(1)/drill/config.h'
    $(SED) -i 's#cp drill/drill#cp drill/drill.exe#' \
        '$(1)/Makefile.in'

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        '--with-ssl=$(PREFIX)/$(TARGET)' \
        exeext=.exe \
        HAVE_INET_NTOP=1 \
        HAVE_INET_PTON=1 \
        --disable-rpath \
        --with-drill

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
