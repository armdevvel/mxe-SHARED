# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bcunit
$(PKG)_WEBSITE  := https://github.com/BelledonneCommunications/$(PKG)
$(PKG)_DESCR    := Unit test tool by Belledonne Communications (LGPL)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2
$(PKG)_CHECKSUM := b9b1cc2f473e0bfa7f5322be60152853acdc8232abfc58dfe6eee5aedc856228
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/archive/refs/heads/release/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS_$(BUILD) := autoconf automake
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && touch README && ./autogen.sh
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
