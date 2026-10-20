# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa-glu
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 9.0.3
$(PKG)_CHECKSUM := bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f
$(PKG)_SUBDIR   := glu-$($(PKG)_VERSION)
$(PKG)_FILE     := glu-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://archive.mesa3d.org/glu/$($(PKG)_FILE)
$(PKG)_DEPS     := cc mesa-gl

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://archive.mesa3d.org, mesa-)
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'

    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' install
endef
