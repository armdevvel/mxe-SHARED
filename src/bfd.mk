# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bfd
$(PKG)_WEBSITE  := https://www.gnu.org/software/binutils/
$(PKG)_IGNORE   :=
$(PKG)_DESCR    := Binary File Descriptor library
$(PKG)_VERSION   = 2.38
$(PKG)_CHECKSUM  = 070ec71cf077a6a58e0b959f05a09a35015378c2d8a51e90f3aeabfe30590ef8
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)/bfd' && ./configure \
        --host='$(TARGET)' \
        --target='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-install-libbfd \
        --disable-shared
    $(MAKE) -C '$(1)/bfd' -j '$(JOBS)'
    $(MAKE) -C '$(1)/bfd' -j 1 install
endef

$(PKG)_BUILD_SHARED =
