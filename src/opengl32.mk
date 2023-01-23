# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opengl32
$(PKG)_WEBSITE  := https://learn.microsoft.com/en-us/windows/win32/opengl/opengl
$(PKG)_DESCR    := Import library generator for WinNT/WinRT-provided opengl32.dll
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1

define $(PKG)_UPDATE
    echo opengl32.dll is updated with MinGW installation.
endef

define $(PKG)_BUILD
	cd '$(BUILD_DIR)' && '$(PREFIX)/bin/gendef' '$(PREFIX)/$(TARGET)/bin/opengl32.dll' - \
		> '$(BUILD_DIR)/opengl32.def'
	'$(TARGET)-dlltool' -d '$(BUILD_DIR)/opengl32.def' -l '$(BUILD_DIR)/libopengl32.a'
	$(INSTALL) -m644 '$(BUILD_DIR)/libopengl32.a' '$(PREFIX)/$(TARGET)/lib/'
endef
