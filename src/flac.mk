# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flac
$(PKG)_WEBSITE  := https://www.xiph.org/flac/
$(PKG)_DESCR    := Free Lossless Audio Codec
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := e322d58a1f48d23d9dd38f432672865f6f79e73a6f9cc5a5f57fcaa83eb5a8e4
$(PKG)_SUBDIR   := flac-$($(PKG)_VERSION)
$(PKG)_FILE     := flac-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://downloads.xiph.org/releases/flac/$($(PKG)_FILE)
$(PKG)_DEPS     := cc ogg $(BUILD)~nasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://downloads.xiph.org/releases/flac/' | \
    $(SED) -n 's,.*<a href="flac-\([0-9][0-9.]*\)\.tar\.[gx]z">.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    $(if $(BUILD_STATIC), \
        $(SED) -i 's/^\(Cflags:.*\)/\1 -DFLAC__NO_DLL/' \
            '$(1)/src/libFLAC/flac.pc.in' \
            '$(1)/src/libFLAC++/flac++.pc.in',)
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doxygen-docs \
        --disable-examples \
        --disable-xmms-plugin \
        --enable-cpplibs \
        --enable-ogg \
        --disable-oggtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= LDFLAGS='`$(MXE_INTRINSIC_SH) chkstk.S.obj`'
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
