# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wmffix
$(PKG)_WEBSITE  := https://download.pahaze.net/ARM/mxe/wmffix/
$(PKG)_DESCR    := wmffix - Windows Media Foundation fixer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := 6b14aa85590aa46cd47c0f6547dd1c0824711208437c283350a31ef90b09052c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://download.pahaze.net/ARM/mxe/wmffix/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	# build and install the library
    cd '$(BUILD_DIR)' && armv7-w64-mingw32-cmake '$(SOURCE_DIR)'
	$(MAKE) -C '$(BUILD_DIR)' -j
	$(MAKE) -C '$(BUILD_DIR)' install
endef