# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opengl-headers
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/OpenGL-Registry
$(PKG)_DESCR    := OpenGL and GLES headers maintained by Khronos Group
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6
$(PKG)_CHECKSUM := 26fea2201a6ef72868bdf899275562452b6ce07c955393d5e47cf298a0763bc8
$(PKG)_SUBDIR   := OpenGL-Registry-rakko-2023-api
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/treeswift/OpenGL-Registry/archive/refs/tags/rakko/2023-api.tar.gz

define $(PKG)_UPDATE
    echo Registry updates are manual -- stay tuned.
endef

define $(PKG)_BUILD
	cd '$(SOURCE_DIR)/api' && for header in `find -name *.h` ; do \
		$(INSTALL) -D -m644 "$$header" '$(PREFIX)/$(TARGET)/include/'; \
	done
endef
