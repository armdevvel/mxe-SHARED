# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libob
$(PKG)_WEBSITE  := https://github.com/OlafSimon/strptime-for-Windows-Linux
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := b2f84cc2bce4125eec2123f16e9502d67fb54ea713d10435c1a0b33accac4b5c
$(PKG)_GH_CONF  := treeswift/strptime/tags,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
