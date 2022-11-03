# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := decaf
$(PKG)_WEBSITE  := https://sourceforge.net/projects/ed448goldilocks/
$(PKG)_DESCR    := Elliptic curve library (BSD license w/ public domain sections) -- Linphone fork
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5
$(PKG)_CHECKSUM := 5095a19c18d02b764b8d60d3b6a9e198ec7a31ac4f307bd4a5ff83b50e75d047
$(PKG)_SUBDIR   := $(PKG)-release-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-release-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.linphone.org/BC/public/external/$(PKG)/-/archive/release/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

# Fork mentioned at: https://gitlab.linphone.org/BC/public/bctoolbox/-/issues/3
# Original decaf repo: https://github.com/krionbsd/libdecaf (last release 0.9.4)
# Resource generation scripts use Python3, but it is an mxe requirement already.

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
		'$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
