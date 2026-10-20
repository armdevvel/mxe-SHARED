# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa-gl
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 23.1.7
$(PKG)_CHECKSUM := 409641eadf0ed1c7794797a6f5a0b0195b5580b282166e5ec5629c6bcda6acd3
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
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' install

    # Not (fully) installed with the ninja install
    for i in EGL GL GLES GLES2 GLES3 KHR; do \
        $(INSTALL) -d "$(PREFIX)/$(TARGET)/include/$$i"; \
        $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(PREFIX)/$(TARGET)/include/$$i/"; \
    done

    # PkgConfig stuff
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)' ; \
     echo 'libdir=$${prefix}/lib' ; \
     echo ; \
     echo 'Name: opengl'; \
     echo 'Version: $($(PKG)_VERSION)'; \
	 echo 'Description: OpenGL (Mesa)'; \
     echo 'Libs: -L$${libdir} -lgallium_wgl -lopengl32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/opengl.pc'

    # the test is the famous glxgears example adapted here (MIT license):
    # https://github.com/CalvinHartwell/windows-glxgears/tree/master/glxgears
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic  \
        -I$(1)/include -lopengl32 -lgdi32 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-glxgears.exe'
endef
