# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libiberty
$(PKG)_WEBSITE  := https://gcc.gnu.org/onlinedocs/libiberty/
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = 2.38
$(PKG)_CHECKSUM  = 070ec71cf077a6a58e0b959f05a09a35015378c2d8a51e90f3aeabfe30590ef8
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)/libiberty
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-install-libiberty
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install target_header_dir=libiberty

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libiberty.exe' \
        -I$(PREFIX)/$(TARGET)/include/libiberty -liberty
endef

$(PKG)_BUILD_SHARED =
