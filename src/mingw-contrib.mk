# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mingw-contrib
$(PKG)_WEBSITE  := https://download.pahaze.net/ARM/mxe/mingw-contrib/
$(PKG)_DESCR    := mingw-contrib - Fixes for missing or outdated libraries in LLVM-MinGW
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3
$(PKG)_CHECKSUM := 4b8612da790cf9d46635d2b394aa83b76d47baac4e0e9d15b2eaf1f1c14933a6
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/armdevvel/mingw-contrib/releases/download/$($(PKG)_VERSION)/mingw-contrib-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	# build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
	$(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
	$(MAKE) -C '$(BUILD_DIR)' install
endef
