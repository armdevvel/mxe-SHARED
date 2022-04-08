# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openssl
$(PKG)_WEBSITE  := https://www.openssl.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.1k
$(PKG)_CHECKSUM := c94dcec69a0462eb6e0362f2adfb0e4ce721ea520605dfad31266b2aa22548cc
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-src.tar.gz
$(PKG)_URL      := https://download.pahaze.net/ARM/mxe/OpenSSL/src/MSVC.tar.gz
$(PKG)_DEPS     := cc zlib

define $(PKG)_BUILD
    cp $(PREFIX)/../resources/MSVC-OpenSSL/lib/* $(PREFIX)/$(TARGET)/lib
	cp -r $(PREFIX)/../resources/MSVC-OpenSSL/include/* $(PREFIX)/$(TARGET)/include
	cp $(PREFIX)/../resources/MSVC-OpenSSL/bin/* $(PREFIX)/$(TARGET)/bin

	sed 's,%PREFIX%,$(PREFIX)/$(TARGET),' \
		< '$(SOURCE_DIR)/libcrypto.pc' > '$(PREFIX)/$(TARGET)/lib/pkgconfig/libcrypto.pc'
	sed 's,%PREFIX%,$(PREFIX)/$(TARGET),' \
		< '$(SOURCE_DIR)/libssl.pc' > '$(PREFIX)/$(TARGET)/lib/pkgconfig/libssl.pc'
	sed 's,%PREFIX%,$(PREFIX)/$(TARGET),' \
		< '$(SOURCE_DIR)/openssl.pc' > '$(PREFIX)/$(TARGET)/lib/pkgconfig/openssl.pc'
endef