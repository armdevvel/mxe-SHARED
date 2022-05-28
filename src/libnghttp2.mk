# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libnghttp2
$(PKG)_WEBSITE  := https://github.com/nghttp2/nghttp2
$(PKG)_DESCR    := HTTP/2 C Library and tools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.47.0
$(PKG)_CHECKSUM := 68271951324554c34501b85190f22f2221056db69f493afc3bbac8e7be21e7cc
$(PKG)_SUBDIR   := nghttp2-$($(PKG)_VERSION)
$(PKG)_FILE     := nghttp2-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/nghttp2/nghttp2/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl libxml2 libevent jansson zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake -DENABLE_EXAMPLES=OFF '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef