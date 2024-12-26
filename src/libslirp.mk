# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libslirp
$(PKG)_WEBSITE  := https://gitlab.freedesktop.org/slirp/libslirp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.0
$(PKG)_SUBDIR   := libslirp-v$($(PKG)_VERSION)
$(PKG)_FILE     := libslirp-v$($(PKG)_VERSION).tar.gz
$(PKG)_CHECKSUM := 7a986863098ce4a938ca88e89befd474ae7d9266edd1178fbdcd3b8e0dd10414
$(PKG)_URL      := https://gitlab.freedesktop.org/slirp/$(PKG)/-/archive/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib meson-wrapper

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        $(PKG_MESON_OPTS) \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libslirp.exe' \
        `'$(TARGET)-pkg-config' slirp --cflags --libs`
endef
