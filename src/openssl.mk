# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openssl
$(PKG)_WEBSITE  := https://www.openssl.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.7
$(PKG)_CHECKSUM := 83049d042a260e696f62406ac5c08bf706fd84383f945cf21bd61e9ed95c396e
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.openssl.org/source/old/$(call tr,$([a-z]),,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_MAKE = $(MAKE) -C '$(1)' -j '$(JOBS)'\
        CC='$(TARGET)-gcc' \
        RANLIB='$(TARGET)-ranlib' \
        AR='$(TARGET)-ar' \
        RC='$(TARGET)-windres' \
        CROSS_COMPILE='$(TARGET)-' \
        RCFLAGS='-I$(PREFIX)/$(TARGET)/include' \
        $(if $(BUILD_SHARED), ENGINESDIR='$(PREFIX)/$(TARGET)/bin/engines')

define $(PKG)_BUILD
    # remove previous install
    rm -rfv '$(PREFIX)/$(TARGET)/include/openssl'
    rm -rfv '$(PREFIX)/$(TARGET)/bin/engines'
    rm -fv '$(PREFIX)/$(TARGET)/'*/{libcrypto*,libssl*}
    rm -fv '$(PREFIX)/$(TARGET)/lib/pkgconfig/'{libcrypto*,libssl*,openssl*}

    # MOREINFO shall we choose --api=... explicitly? In other words, is 3.x any better than 1.0.2?
    cd '$(1)' && CC='$(TARGET)-gcc' RC='$(TARGET)-windres' ./Configure \
        mingw-arm \
        zlib \
        $(if $(BUILD_STATIC),no-module no-,)shared \
        no-capieng \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib'
    $($(PKG)_MAKE) build_sw
    $($(PKG)_MAKE) install_sw
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && ./Configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        no-module no-shared \
    && make -j 1 \
        $(if $(BUILD_SHARED), ENGINESDIR='$(PREFIX)/$(TARGET)/bin/engines') \
        install_sw
endef