# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libffi
$(PKG)_WEBSITE  := https://sourceware.org/libffi/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := 19a286554010491e5d84ab8bc8f2c4449f3d7a6fee812eacfe222e5cc55384b6
$(PKG)_GH_CONF  := atgreen/libffi/tags, v
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/armdevvel/libffi/releases/download/3.3/libffi-3.3.tar.gz
$(PKG)_URL_2    := https://github.com/armdevvel/libffi/releases/download/3.3/libffi-3.3.tar.gz
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc

$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

endef

define $(PKG)_BUILD_$(BUILD)
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
