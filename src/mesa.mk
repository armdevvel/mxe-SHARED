PKG             := mesa
$(PKG)_VERSION  := 21.3
$(PKG)_CHECKSUM := 0a7eed28eb682a8fa66aee861c9cd0d6a0266876a81db6a5b5c7527f4838fed3
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.freedesktop.org/$(PKG)/$(PKG)/-/archive/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && meson \
        --cross-file=$(PWD)/cross.txt \
        --prefix '$(PREFIX)/$(TARGET)/mesa' \
		-D egl=enabled \
		-D dri-drivers=auto \
		-D gallium-drivers=d3d12,tegra,swr,swrast,auto \
		-D gles1=enabled \
		-D gles2=enabled \
		-D glx=disabled \
		-D shared-glapi=enabled \
        build-arm

	# Unknown target: libgl-gdi (was passed to SCons)
	cd '$(SOURCE_DIR)/build-arm' && ninja && meson install
endef
