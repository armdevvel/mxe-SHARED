# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := geos
$(PKG)_WEBSITE  := https://trac.osgeo.org/geos/
$(PKG)_DESCR    := GEOS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.9.1
$(PKG)_CHECKSUM := 7e630507dcac9dc07565d249a26f06a15c9f5b0c52dd29129a0e3d381d7e382a
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.osgeo.org/geos/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # NOTE there is a CMake build, wondering if we might prefer it
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-inline

    # NOTE use a single component to inject CLang builtin objects
    $(MAKE) -C '$(1)/src/util' -j '$(JOBS)' \
        LDFLAGS='`$(MXE_INTRINSIC_SH) aeabi_{,u}{i,l}divmod.S.obj {,u}divmodsi4.S.obj {,u}divmoddi4.c.obj {fix{,uns}dfdi,floatdidf}.c.obj chkstk.S.obj`' \
        $(MXE_DISABLE_PROGRAMS)

    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(1)' -j 1 $(INSTALL_STRIP_LIB)

    ln -sf '$(PREFIX)/$(TARGET)/bin/geos-config' '$(PREFIX)/bin/$(TARGET)-geos-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-geos.exe' \
        `'$(PREFIX)/bin/$(TARGET)-geos-config' --cflags --clibs`
endef
