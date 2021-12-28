# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := eglgears
$(PKG)_WEBSITE  := https://gist.github.com/tmpvar/445146
$(PKG)_DESCR    := This is a port of the infamous "glxgears" demo to straight EGL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 99
$(PKG)_CHECKSUM := 10ea057d037501ee59512c47af12e5763878e48d724b94f93fd11fb7cb79f6bb
$(PKG)_SUBDIR   := 445146-4f9b3eddca545670be6ac9a836a4ce9187c733ec
$(PKG)_FILE     := 4f9b3eddca545670be6ac9a836a4ce9187c733ec.tar.gz
$(PKG)_URL      := https://gist.github.com/tmpvar/445146/archive/4f9b3eddca545670be6ac9a836a4ce9187c733ec.tar.gz
$(PKG)_DEPS     := cc angle

define $(PKG)_BUILD
    '$(PREFIX)/bin/$(TARGET)-cc' '$(SOURCE_DIR)/$(PKG).c' -o '$(BUILD_DIR)/$(PKG).exe' \
		'-I$(PREFIX)/$(TARGET)/include' `'$(PREFIX)/$(TARGET)/lib/pkgconfig' -cflags --libs egl`
	$(INSTALL) -m 755 '$(BUILD_DIR)/$(PKG).exe' '$(PREFIX)/$(TARGET)/bin/'
endef
