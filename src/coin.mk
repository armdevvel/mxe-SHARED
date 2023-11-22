# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := coin
$(PKG)_WEBSITE  := https://bitbucket.org/Coin3D/
$(PKG)_DESCR    := Coin3D
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.3
$(PKG)_CHECKSUM := 583478c581317862aa03a19f14c527c3888478a06284b9a46a0155fa5886d417
$(PKG)_SUBDIR   := Coin-$($(PKG)_VERSION)
$(PKG)_FILE     := Coin-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/Coin3D/coin/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 mesa mesa-glu $(BUILD)~slibtool

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/Coin3D/coin/downloads' | \
    $(SED) -n 's,.*Coin-\([0-9.]*\).tar.gz.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    sed -i '$(1)/include/Inventor/elements/SoGLLazyElement.h' \
        -e 's#typedef struct COIN_DLL_API#typedef struct GLState#'

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --enable-compact \
        --enable-3ds-import \
        --without-x \
        CXXFLAGS=-Wno-c++11-narrowing \
        LDFLAGS="`$(TARGET)-pkg-config mesa --libs` -ldl -lgdi32 -lwinmm" \
        OBJDUMP=$(TARGET)-objdump \
        NM=$(TARGET)-nm \
        COIN_STATIC=$(if $(BUILD_STATIC),true,false)

    $(MAKE) -C '$(1)' -j '$(JOBS)' LIBTOOL=$(PREFIX)/midipix/bin/slibtool-$(if $(BUILD_STATIC),static,shared) install

    # *.la isn't the way it should be -- see TODOs in slibtool commit ec296aa;
    # keep these replacements for reference, use pkg-config downstream instead
    # $(SED) -i '$(PREFIX)/$(TARGET)/lib/libCoin.la' \
    #     -e "/library_names/s#.dll#.dll.a#g" -e "/old_library/s#'.*'#''#" \
    #     -e "s#dependency_libs='#&`$(TARGET)-pkg-config mesa --libs` -ldl -lgdi32 -lwinmm#" # TODO DRY

    '$(TARGET)-g++' \
        -W -Wall -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-coin.exe' \
        -D$(if $(BUILD_STATIC),COIN_NOT_DLL,COIN_DLL) \
        `'$(TARGET)-pkg-config' Coin --cflags --libs`
endef
