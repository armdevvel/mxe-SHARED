# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := exiv2
$(PKG)_WEBSITE  := https://www.exiv2.org/
$(PKG)_DESCR    := Exiv2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.27.5
$(PKG)_CHECKSUM := 35a58618ab236a901ca4928b0ad8b31007ebdc0386d904409d825024e45ea6e2
$(PKG)_SUBDIR   := exiv2-$($(PKG)_VERSION)
$(PKG)_FILE     := exiv2-$($(PKG)_VERSION)-Source.tar.gz
$(PKG)_URL      := https://github.com/Exiv2/exiv2/releases/download/v0.27.5/$($(PKG)_FILE)
$(PKG)_DEPS     := cc expat gettext mman-win32 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.exiv2.org/download.html' | \
    grep 'href="exiv2-' | \
    $(SED) -n 's,.*exiv2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)-Source' && mkdir build && cd build
    cd '$(1)-Source/build' && $(TARGET)-cmake ..
    cd '$(1)-Source/build' && make -j '$(JOBS)' install
endef
