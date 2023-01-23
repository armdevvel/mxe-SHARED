# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mingw-contrib
$(PKG)_WEBSITE  := https://download.pahaze.net/ARM/mxe/mingw-contrib/
$(PKG)_DESCR    := mingw-contrib - Fixes for missing or outdated libraries in LLVM-MinGW
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 3eeb0e7b169c49359a7caed81cba8b3f89704fe713a49b87c5784a707a8a34d7
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/armdevvel/mingw-contrib/releases/download/$($(PKG)_VERSION)/mingw-contrib-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	# build and install the library
    cd '$(BUILD_DIR)' && armv7-w64-mingw32-cmake '$(SOURCE_DIR)'
	$(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
	$(MAKE) -C '$(BUILD_DIR)' install
endef