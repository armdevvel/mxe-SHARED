# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libprefix
$(PKG)_DESCR    := known path lookup library <paths.h>
$(PKG)_WEBSITE  := https://github.com/armdevvel/prefix
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.1
$(PKG)_CHECKSUM := e2abd0adc625ddd543f2c54a1ce723d5a574ac4228db846007eb061681f54ed5
$(PKG)_GH_CONF  := armdevvel/prefix/tags,
$(PKG)_DEPS     := cc meson-wrapper

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
