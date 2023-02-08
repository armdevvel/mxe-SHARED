# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwusers
$(PKG)_WEBSITE  := https://github.com/treeswift/libwusers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.3
$(PKG)_CHECKSUM := 60287d0383215ed25497b1e2fa705239fc4e829d81a3809ec00c5a5b6bb447e6
$(PKG)_GH_CONF  := treeswift/libwusers/tags/tag,,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install

    # fixing import library naming and placement
    mv '$(PREFIX)/$(TARGET)/bin/libwusers.dll.a' \
       '$(PREFIX)/$(TARGET)/lib/libwusers.a'
endef
