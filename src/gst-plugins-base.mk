# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gst-plugins-base
$(PKG)_WEBSITE  := https://gstreamer.freedesktop.org/modules/gst-plugins-base.html
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.20.2
$(PKG)_CHECKSUM := ab0656f2ad4d38292a803e0cb4ca090943a9b43c8063f650b4d3e3606c317f17
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gstreamer.freedesktop.org/src/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glib gstreamer liboil libxml2 ogg pango theora vorbis

$(PKG)_UPDATE = $(subst gstreamer/refs,gst-plugins-base/refs,$(gstreamer_UPDATE))

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt \
    -Dexamples=disabled \
    -Dtests=disabled \
    build
    $(SED) -i 's/LINK_ARGS = /LINK_ARGS = -lssp /g' '$(SOURCE_DIR)/build/build.ninja'
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install

    # some .dlls are installed to lib - no obvious way to change
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0'
    mv -vf '$(PREFIX)/$(TARGET)/lib/gstreamer-1.0/'*.dll '$(PREFIX)/$(TARGET)/bin/gstreamer-1.0/'
endef
