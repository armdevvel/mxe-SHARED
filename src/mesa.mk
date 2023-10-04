# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 22.3.2
$(PKG)_CHECKSUM := c15df758a8795f53e57f2a228eb4593c22b16dffd9b38f83901f76cd9533140b
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://archive.mesa3d.org/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper zlib zstd

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://archive.mesa3d.org, mesa-)
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dllvm=false \
        -Dbuild-tests=false \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'

    # the test is the famous glxgears example adapted here (MIT license):
    # https://github.com/CalvinHartwell/windows-glxgears/tree/master/glxgears
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic  \
        -I$(1)/include -Wl,'$(BUILD_DIR)/src/gallium/targets/libgl-gdi/opengl32.dll.a' -lgdi32 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-glxgears.exe'

    # manual install to avoid clobbering platform opengl driver
    for i in EGL GL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/mesa'
    $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/wgl/libgallium_wgl.dll' '$(PREFIX)/$(TARGET)/bin/mesa/'
    $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/libgl-gdi/opengl32.dll' '$(PREFIX)/$(TARGET)/bin/mesa/'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/mesa'
    $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/wgl/libgallium_wgl.dll.a' '$(PREFIX)/$(TARGET)/lib/mesa/'
    $(INSTALL) -m 755 '$(BUILD_DIR)/src/gallium/targets/libgl-gdi/opengl32.dll.a' '$(PREFIX)/$(TARGET)/lib/mesa/'
endef
