# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := getline-compatible
$(PKG)_WEBSITE  := https://github.com/treeswift/$(PKG)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 817e6081bac2c45fc27a0114f6803227b3cde7fa164eb33278493ecebffed50d
$(PKG)_GH_CONF  := treeswift/$(PKG)/tags,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
