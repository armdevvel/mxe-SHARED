PKG             := mesa
$(PKG)_VERSION  := 21.3
$(PKG)_CHECKSUM := 0a7eed28eb682a8fa66aee861c9cd0d6a0266876a81db6a5b5c7527f4838fed3
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.freedesktop.org/$(PKG)/$(PKG)/-/archive/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
	# MOREINFO generalize target machine inference?
	# Note: was $(if $(findstring 64,$(TARGET)),x86_64,x86)

	# MOREINFO how to select driver d3d12?

    cd '$(SOURCE_DIR)' && meson \
        --cross-file=$(PWD)/cross.txt \
        --prefix '$(PREFIX)/armv7-w64-mingw32' \
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

    for i in EGL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(SOURCE_DIR)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done
    $(INSTALL) -m 755 '$(SOURCE_DIR)/build-arm/src/gallium/targets/libgl-gdi/opengl32.dll' '$(PREFIX)/$(TARGET)/bin/'
endef
