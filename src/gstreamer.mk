# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gstreamer
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gstreamer.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20.2
$(PKG)_CHECKSUM := df24e8792691a02dfe003b3833a51f1dbc6c3331ae625d143b17da939ceb5e0a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib libxml2 pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://cgit.freedesktop.org/gstreamer/gstreamer/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=[^0-9]*\\([0-9]\..[02468]\.[0-9][^']*\\)'.*,\\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt \
    -Dexamples=disabled \
    -Dtests=disabled \
    -Dgst_debug=false \
    -Dcheck=disabled \
    build
    $(SED) -i 's/-lintl/-lintl -Wl,--allow-multiple-definition/g' '$(SOURCE_DIR)/build/build.ninja'
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef
