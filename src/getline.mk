# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := getline
$(PKG)_WEBSITE  := https://github.com/digilus/getline
$(PKG)_DESCR    := Public domain implementation of getline()
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := f351c4813e0f88c1248f6e6867922ebffa2b67a686becc6508f1790ce867242a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/treeswift/$(PKG)/archive/refs/tags/$($(PKG)_VERSION).tar.gz

$(PKG)_DEPS     := cc

# A trivial pkgconfig would be:
#
# prefix=$(PREFIX)/$(TARGET)
# includedir=${prefix}/include
#
# Name: Getline
# Description: $($(PKG)_DESCR)
# Version: $($(PKG)_VERSION)
# Libs: getline.o
# Cflags: -I${includedir}
#
# We can add it later if needed.

define $(PKG)_BUILD
    cd $(1) && $(TARGET)-gcc \
            -c -o getline.o getline.c && \
        $(INSTALL) -m644 getline.o $(PREFIX)/$(TARGET)/lib && \
        $(INSTALL) -m644 getline.h $(PREFIX)/$(TARGET)/include
endef
