# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://github.com/unicode-org/icu
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 74.2
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 68db082212a96d6f53e35d60f47d38b962e9f9d207a74cfac78029ae8ff5e08c
$(PKG)_GH_CONF  := unicode-org/icu/releases/latest,release-,,,-
$(PKG)_SUBDIR   := icu
$(PKG)_URL      := $($(PKG)_WEBSITE)/releases/download/release-$(subst .,-,$($(PKG)_VERSION))/icu4c-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_DEPS     := cc $(BUILD)~$(PKG)

$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD_$(BUILD)
    # cross build requires artefacts from native build tree
    rm -rf '$(PREFIX)/$(BUILD)/$(PKG)'
    $(INSTALL) -d '$(PREFIX)/$(BUILD)/$(PKG)'
    cd '$(PREFIX)/$(BUILD)/$(PKG)' && '$(SOURCE_DIR)/source/configure' \
        CC=$(BUILD_CC) \
        CXX=$(BUILD_CXX) \
        --enable-tests=no \
        --enable-samples=no
    $(MAKE) -C '$(PREFIX)/$(BUILD)/$(PKG)' -j '$(JOBS)'
endef

define $(PKG)_BUILD_COMMON
    # '?*' to avoid matching plain "libicu.a" from gcc.
    rm -fv $(shell echo "$(PREFIX)/$(TARGET)"/{bin,lib}/{lib,libs,}icu'?*'.{a,dll,dll.a})
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(PREFIX)/$(BUILD)/$(PKG)' \
        --enable-icu-config=no \
        CXXFLAGS='--std=gnu++0x' \
        SHELL=$(SHELL) \
        LIBS='-lstdc++' \
        $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 SO_TARGET_VERSION_SUFFIX=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1 SO_TARGET_VERSION_SUFFIX=

    $(if $(BUILD_RELEASE), \
        mv -fv '$(PREFIX)/$(TARGET)/bin/icudt74.dll' '$(PREFIX)/$(TARGET)/bin/icudt74-stubdata.dll' && \
        mv -fv '$(PREFIX)/$(TARGET)/bin/libicudt74.dll' '$(PREFIX)/$(TARGET)/bin/icudt74.dll' \
    ,)

    $(if $(BUILD_DEBUG),$($(PKG)_BUILD_COPY_DLLS),)
endef

define $(PKG)_BUILD_COPY_DLLS
    # Debug builds save libraries to libicu*d.dll.a.
    # This causes issues with things like Qt's configure system.
    # TODO: Fix Qt's configure system in the future to accept libicu*d.dll.a(?)
    cp $(PREFIX)/$(TARGET)/lib/libicudtd.dll.a $(PREFIX)/$(TARGET)/lib/libicudt.dll.a
    cp $(PREFIX)/$(TARGET)/lib/libicutestd.dll.a $(PREFIX)/$(TARGET)/lib/libicutest.dll.a
    cp $(PREFIX)/$(TARGET)/lib/libicuind.dll.a $(PREFIX)/$(TARGET)/lib/libicuin.dll.a
    cp $(PREFIX)/$(TARGET)/lib/libicutud.dll.a $(PREFIX)/$(TARGET)/lib/libicutu.dll.a
    cp $(PREFIX)/$(TARGET)/lib/libicuiod.dll.a $(PREFIX)/$(TARGET)/lib/libicuio.dll.a
    cp $(PREFIX)/$(TARGET)/lib/libicuucd.dll.a $(PREFIX)/$(TARGET)/lib/libicuuc.dll.a
    # Also, icudt(d) by default is a *stub* library. libicudt(d) contains the real deal.
    mv $(PREFIX)/$(TARGET)/bin/icudtd69.dll $(PREFIX)/$(TARGET)/bin/icudtd69-stubdata.dll
    mv $(PREFIX)/$(TARGET)/bin/libicudtd69.dll $(PREFIX)/$(TARGET)/bin/icudtd69.dll
endef

define $(PKG)_BUILD_TEST
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' icu-uc icu-io --cflags --libs`
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    $($(PKG)_BUILD_TEST)
endef
