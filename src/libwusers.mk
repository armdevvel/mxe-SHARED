# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwusers
$(PKG)_WEBSITE  := https://github.com/treeswift/libwusers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := 96b24e7d9a1d11dfc002418b924454cf08dc4e7172f9959f0975532b03895cdc
$(PKG)_GH_CONF  := treeswift/libwusers/tags,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install

    # fixing import library naming and placement
    mv '$(PREFIX)/$(TARGET)/bin/libwusers.dll.a' \
       '$(PREFIX)/$(TARGET)/lib/libwusers.a'
endef
