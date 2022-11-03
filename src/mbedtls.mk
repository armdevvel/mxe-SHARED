# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mbedtls
$(PKG)_WEBSITE  := https://www.trustedfirmware.org/projects/mbed-tls/
$(PKG)_DESCR    := Embeddable TLS implementation (Apache 2.0 license)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := d0e77a020f69ad558efc660d3106481b75bd3056d6301c31564e04a0faae88cc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Mbed-TLS/$(PKG)/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

# DESTDIR=$(PREFIX)/$(TARGET) 
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake -v \
		-DENABLE_TESTING=Off \
		-DUSE_SHARED_MBEDTLS_LIBRARY=$(if $(BUILD_SHARED),On,Off) \
		'$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
