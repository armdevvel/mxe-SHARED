# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := agg
$(PKG)_WEBSITE  := https://antigrain.com/
$(PKG)_DESCR    := Anti-Grain Geometry
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := ab1edc54cc32ba51a62ff120d501eecd55fceeedf869b9354e7e13812289911f
$(PKG)_SUBDIR   := agg-$($(PKG)_VERSION)
$(PKG)_FILE     := agg-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://antigrain.com/$($(PKG)_FILE)
$(PKG)_URL_2    := https://web.archive.org/web/20170111090029/www.antigrain.com/$($(PKG)_FILE)
$(PKG)_DEPS     := cc freetype sdl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://antigrain.com/download/index.html' | \
    $(SED) -n 's,.*<A href="https://antigrain.com/agg-\([0-9.]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(foreach f,authors news readme, mv '$(1)/$f' '$(1)/$f_';mv '$(1)/$f_' '$(1)/$(call uc,$f)';)
    
    # unpack enough CLang-RT builtin implementations for injection...
    $(MXE_INTRINSIC_SH) {aeabi_{,u}idivmod,{,u}divmodsi4,chkstk}.S.obj

    # first, configure for a static build, for the Win32 entry point
    cd '$(1)' && autoreconf -fi -I $(PREFIX)/$(TARGET)/share/aclocal
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static --disable-shared \
        --without-x

    # now build the static entry point library that calls agg_main()
    $(MAKE) -C '$(1)/src/platform/win32' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= \
        LDFLAGS="`$(MXE_INTRINSIC_SH) floatdidf.c.obj`" \
        libaggplatformwin32_la_DEPENDENCIES= \
        libaggplatformwin32_la_LIBADD=-lgdi

    # now skip the platform, examples and reconfigure
    $(SED) -e 's! *platform!!' -i '$(1)/src/Makefile.am'
    $(SED) -e 's! *examples!!' -i '$(1)/Makefile.am'
    cd '$(1)' && autoreconf -fi -I $(PREFIX)/$(TARGET)/share/aclocal
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-x

    # brute force in lieu of backticks and shell brace expansion
    $(SED) -i '$(1)/src/Makefile' \
        -e "s#am_libagg_la_OBJECTS =#& \
            $(BUILD_DIR)/aeabi_uidivmod.S.obj.lo \
            $(BUILD_DIR)/udivmodsi4.S.obj.lo \
            $(BUILD_DIR)/chkstk.S.obj.lo \
        #"

    # same for font_win32_tt + font_freetype + clarify deps + allow a DLL build:
    $(SED) -i '$(1)/font_freetype/Makefile' \
              '$(1)/font_win32_tt/Makefile' \
        -e 's#la_LDFLAGS = *#&\
            $(BUILD_DIR)/aeabi_idivmod.S.obj.lo \
            $(BUILD_DIR)/aeabi_uidivmod.S.obj.lo \
            $(BUILD_DIR)/divmodsi4.S.obj.lo \
            $(BUILD_DIR)/udivmodsi4.S.obj.lo \
            $(BUILD_DIR)/chkstk.S.obj.lo \
        -no-undefined #'
    $(SED) -i '$(1)/font_freetype/Makefile' \
        -e 's#libaggfontfreetype_la_LIBADD = *#& $$(top_builddir)/src/libagg.la#'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
