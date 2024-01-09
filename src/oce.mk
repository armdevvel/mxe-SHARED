# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := oce
$(PKG)_WEBSITE  := https://github.com/tpaviot/oce
$(PKG)_DESCR    := Open CASCADE Community Edition
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.2
$(PKG)_CHECKSUM := dc21ddea678a500ad87c773e9a502ed7a71768cf83d9af0bd4c43294186a7fef
$(PKG)_GH_CONF  := tpaviot/oce/tags,OCE-
$(PKG)_DEPS     := cc freetype mesa mesa-glu

define $(PKG)_BUILD
    # HAVE_VIDEOCAPTURE requires vfw32.lib (import library of avifil32.dll and msvf32.dll),
    # but these DLLs are not available on newer versions of Windows, presumably due to the
    # deprecation of the AVI format. Until we have a replacement for OpenGL_AVIWRiter.cxx,
    # simply make the dependency (and the macro) conditional upon OCE_HAVE_VIDEOCAPTURE.

    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DOCE_BUILD_SHARED_LIB=$(CMAKE_SHARED_BOOL) \
        -DOCE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        -DOCE_INSTALL_BIN_DIR=$(PREFIX)/$(TARGET)/bin \
        -DOCE_INSTALL_LIB_DIR=$(PREFIX)/$(TARGET)/lib \
        -DOCE_INSTALL_CMAKE_DATA_DIR=$(PREFIX)/$(TARGET)/lib/cmake/OCE \
        -DOCE_HAVE_VIDEOCAPTURE:Bool=OFF \
        -DOCE_AUTOINSTALL_DEPENDENT_LIBS=OFF

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    cd '$(SOURCE_DIR)/examples/find_package_oce' && '$(TARGET)-cmake' .
    $(MAKE) -C '$(SOURCE_DIR)/examples/find_package_oce'
endef

