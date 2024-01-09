# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcaca
$(PKG)_WEBSITE  := http://caca.zoy.org/wiki/libcaca
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.99.beta19
$(PKG)_CHECKSUM := 128b467c4ed03264c187405172a4e83049342cc8cc2f655f53a2d0ee9d3772f4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://caca.zoy.org/files/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 freeglut ncurses zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://caca.zoy.org/wiki/libcaca' | \
    $(SED) -n 's,.*/libcaca-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -rV | \
    head -1
endef

define $(PKG)_BUILD
    sed -i 's#-fno-strength-reduce##' '$(SOURCE_DIR)/configure.ac'
    cd '$(SOURCE_DIR)' && autoreconf -fi
    $(if $(BUILD_STATIC),                                         \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca.h'; \
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/caca/caca0.h')
    cd '$(BUILD_DIR)' && \
    env GL_CFLAGS='-I$(PREFIX)/$(TARGET)' \
    env GL_LIBS="`$(TARGET)-pkg-config --libs mesa`" \
    '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-csharp \
        --disable-java \
        --disable-python \
        --disable-ruby \
        --disable-doc \
        CFLAGS='-D_WIN32=1 -DDLL_EXPORT=1 -DUSE_WINSOCK=1' \
        CACA_LIBS="-lws2_32 `$(MXE_INTRINSIC_SH) chkstk.S.obj`" \
        $(if $(BUILD_STATIC), LIBS=-luuid)

    # NOTE: https://www.gnu.org/software/libtool/manual/html_node/Stripped-link-flags.html
    # TL;DR libtool silently censors ld flags. A good commie is one resting 3' underground.
    $(MAKE) -C '$(BUILD_DIR)/caca' -j '$(JOBS)' \
        LDFLAGS='-XCClinker -Wl,--export-all-symbols'
    sed -i "s#^LIBS =#LIBS = `$(MXE_INTRINSIC_SH) chkstk.S.obj`#" '$(BUILD_DIR)/cxx/Makefile'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/caca-config' '$(PREFIX)/bin/$(TARGET)-caca-config'
endef

