# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmemmap
$(PKG)_DESCR    := *nix VM API on Windows
$(PKG)_WEBSITE  := https://github.com/treeswift/$(PKG)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.2
$(PKG)_CHECKSUM := 562e90fb0ca96a790794cfb06759a07e299db8df1d7826e1554fd6283aa4f263
$(PKG)_GH_CONF  := treeswift/$(PKG)/tags,
$(PKG)_DEPS     := cc libfatctl

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
