# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libffi
$(PKG)_WEBSITE  := https://sourceware.org/libffi/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := f0adc5871d908fab414b17e066abb6f18438bab0d6d128051631ed3cd4c46dba
$(PKG)_GH_CONF  := atgreen/libffi/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/armdevvel/libffi/releases/download/3.3-fixed/libffi-3.3.fixed.tar.xz
$(PKG)_URL_2    := https://github.com/armdevvel/libffi/releases/download/3.3-fixed/libffi-3.3.fixed.tar.xz
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    patch -p1 < fixmakefile.patch
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

endef

define $(PKG)_BUILD_$(BUILD)
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    patch -p1 < fixmakefile.patch
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
