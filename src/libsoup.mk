# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsoup
$(PKG)_WEBSITE  := https://wiki.gnome.org/Projects/libsoup
$(PKG)_DESCR    := An HTTP client/server library for GNOME
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.6
$(PKG)_CHECKSUM := b45d59f840b9acf9bb45fd45854e3ef672f57e3ab957401c3ad8d7502ac23da6
$(PKG)_SUBDIR   := libsoup-$($(PKG)_VERSION)
$(PKG)_FILE     := libsoup-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libsoup/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libidn2 libiconv libpsl 

define $(PKG)_BUILD
    cp '$(SOURCE_DIR)/../../cross.txt' '$(SOURCE_DIR)'
    cd '$(SOURCE_DIR)' && meson \
    --cross-file=cross.txt \
    --prefix '$(PREFIX)/armv7-w64-mingw32' \
    -Dtls_check=false \
    -Dtests=false \
    build
    # Packages never add what's really required for their libs... (Also have to temporarily hardcode armv7's pkg config)
    $(SED) -i 's/-lpsl/`armv7-w64-mingw32-pkg-config --libs libpsl libidn2`/g' '$(SOURCE_DIR)/build/build.ninja'

    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef
