# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xapian-core
$(PKG)_WEBSITE  := https://xapian.org/
$(PKG)_DESCR    := Xapian-Core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.16
$(PKG)_CHECKSUM := 4937f2f49ff27e39a42150e928c8b45877b0bf456510f0785f50159a5cb6bf70
$(PKG)_SUBDIR   := xapian-core-$($(PKG)_VERSION)
$(PKG)_FILE     := xapian-core-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://oligarchy.co.uk/xapian/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://xapian.org/download | \
    $(SED) -n 's,.*<a HREF="https://oligarchy.co.uk/xapian/\([^/]*\)/xapian-core[^"]*">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # see protobuf.mk -- the applied fix is a development of that one:
    sed -i 's#-L\* \x7c -R\* \x7c -l\*#& | *clang_rt*#' '$(SOURCE_DIR)/m4/libtool.m4'
    sed -i '$(SOURCE_DIR)/ltmain.sh' \
        -e 's#deplib is not portable!"#deplib is now allowed."; deplib="-XCCLinker -Wl,$$deplib"#' \
        -e 's#valid_a_lib=false#valid_a_lib=:#'

    sed -i 's#AC_DEFINE..__MSVCRT_VERSION__.#dnl &NO_#' '$(SOURCE_DIR)/configure.ac'

    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)

    #  now final injection of the runtimes:
    sed -i '$(BUILD_DIR)/libtool' \
        -e 's#postdeps="-#&lclang_rt.builtins-arm -#' \
        -e 's#-lmsvcrt#-lucrt -lssp#g'

    #  _stati64 is history together with msvcrt.
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) \
        CXXFLAGS='-D_UCRT=1'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
