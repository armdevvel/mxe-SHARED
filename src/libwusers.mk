# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwusers
$(PKG)_WEBSITE  := https://github.com/treeswift/libwusers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.4
$(PKG)_CHECKSUM := 7b74e98856f76ea5f9505f05cc540aa286c25bf98e3967d5c77140d412def013
$(PKG)_GH_CONF  := treeswift/libwusers/tags/tag,,,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target install

    # fixing import library naming and placement
    mv '$(PREFIX)/$(TARGET)/bin/libwusers.dll.a' \
       '$(PREFIX)/$(TARGET)/lib/libwusers.a'
endef
