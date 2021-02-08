# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsamplerate
$(PKG)_WEBSITE  := 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.9
$(PKG)_CHECKSUM := 4d12558cd11993adcd7445954a4a4f930caaa63d9baffbd36a6c42013cff3573
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/armdevvel/libsamplerate-0.1.9/releases/download/v0.1.9-fixed/libsamplerate-0.1.9.tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # fftw and sndfile are only used for tests/examples
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-fftw \
        --disable-sndfile
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS) $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS) $(MXE_DISABLE_DOCS)
endef
