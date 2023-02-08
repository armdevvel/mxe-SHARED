# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwusers
$(PKG)_WEBSITE  := https://github.com/treeswift/libwusers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.2
$(PKG)_CHECKSUM := 68c9f8641ee4bdbd4f965b8c6d0a4e5abc3c2fffad2b66eb7f55f0e2bc03a052
$(PKG)_GH_CONF  := treeswift/libwusers/tags/tag,,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install

    # fixing import library naming and placement
    mv '$(PREFIX)/$(TARGET)/bin/libwusers.dll.a' \
       '$(PREFIX)/$(TARGET)/lib/libwusers.a'
endef
