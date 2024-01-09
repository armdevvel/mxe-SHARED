# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := https://github.com/unicode-org/icu
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 68.2
$(PKG)_MAJOR    := icu.tar.gz
$(PKG)_CHECKSUM := 8764da8c85d8479f816cfc894aea227d98f5b40a9be55db5fd903fdd46806f88
$(PKG)_GH_CONF  := unicode-org/icu/releases/latest,release-,,,-
$(PKG)_SUBDIR   := icu
$(PKG)_URL      := https://github.com/armdevvel/icu4c/releases/download/v68.2/icu68.tar.gz
$(PKG)_DEPS     := cc $(BUILD)~$(PKG) pe-util

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
    rm -fv $(shell echo "$(PREFIX)/$(TARGET)"/{bin,lib}/{lib,libs,}icu'*'.{a,dll,dll.a})
    $(SED) -i 's/-Wl,-Bsymbolic/ /g' '$(SOURCE_DIR)/source/config/mh-mingw'
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
endef

define $(PKG)_BUILD_TEST
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' icu-uc icu-io --cflags --libs`
endef

define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_COMMON)
    # icu4c installs its DLLs to lib/. Move them to bin/.
    mv -fv $(PREFIX)/$(TARGET)/lib/icu*.dll '$(PREFIX)/$(TARGET)/bin/' || true

    # stub data is icudt.dll, actual data is libicudt.dll - prefer actual
    test ! -e '$(PREFIX)/$(TARGET)/lib/libicudt$($(PKG)_MAJOR).dll' \
        || mv -fv '$(PREFIX)/$(TARGET)/lib/libicudt$($(PKG)_MAJOR).dll' '$(PREFIX)/$(TARGET)/bin/icudt$($(PKG)_MAJOR).dll'

    $($(PKG)_BUILD_TEST)
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    $($(PKG)_BUILD_TEST)
endef
