# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa-glu
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := Graphics Library Utilities as hosted by Mesa 3D
$(PKG)_VERSION  := 9.0.3
$(PKG)_CHECKSUM := 7e919cbc1b2677b01d65fc28fd36a19d1f3e23d76663020e0f3b82b991475e8b
$(PKG)_TAG      := glu-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := glu-$($(PKG)_TAG)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://gitlab.freedesktop.org/mesa/glu/-/archive/$($(PKG)_TAG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper mesa

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dgl_provider=mesa \
        -Dc_args='-DRESOLVE_3D_TEXTURE_SUPPORT=1' \
        -Ddefault_library=$(if $(BUILD_SHARED),shared,static) \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' install
endef
