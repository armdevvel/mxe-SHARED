# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mbedtls
$(PKG)_WEBSITE  := https://www.trustedfirmware.org/projects/mbed-tls/
$(PKG)_DESCR    := Embeddable TLS implementation (Apache 2.0 license)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.0
$(PKG)_CHECKSUM := d77cd2edea4ce46e7ab0c2500298212b6475af6e51210ef9c5a6834283c6727f
$(PKG)_SUBDIR   := $(PKG)-SRTP-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/laandersson/$(PKG)-SRTP/archive/refs/tags/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
		-DENABLE_TESTING=Off \
		-DUSE_SHARED_MBEDTLS_LIBRARY=$(if $(BUILD_SHARED),On,Off) \
		'$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
