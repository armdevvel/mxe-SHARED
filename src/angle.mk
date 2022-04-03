# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := angle
$(PKG)_WEBSITE  := https://chromium.googlesource.com/$(PKG)/$(PKG)
$(PKG)_DESCR    := ANGLE - Almost Native Graphics Layer Engine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d15be77864e18f407c317be6f6bc06ee2b7d070a
$(PKG)_CHECKSUM := 6df064353f453b9c85295341e619cabb5de3d6a64c8faed0560cddc723e22505
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := src.tar.gz
$(PKG)_URL      := https://download.pahaze.net/ARM/mxe/ANGLE/src/src.tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
	cp $(PREFIX)/../resources/MSVC-ANGLE/lib/* $(PREFIX)/$(TARGET)/lib
	cp -r $(PREFIX)/../resources/MSVC-ANGLE/include/* $(PREFIX)/$(TARGET)/include

	sed 's,%PREFIX%,$(PREFIX)/$(TARGET),' \
		< '$(SOURCE_DIR)/../egl.pc.in' > '$(PREFIX)/$(TARGET)/lib/pkgconfig/egl.pc'
	sed 's,%PREFIX%,$(PREFIX)/$(TARGET),' \
		< '$(SOURCE_DIR)/../glesv2.pc.in' > '$(PREFIX)/$(TARGET)/lib/pkgconfig/glesv2.pc'
endef