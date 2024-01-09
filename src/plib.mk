# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := plib
$(PKG)_WEBSITE  := https://plib.sourceforge.io/
$(PKG)_DESCR    := Plib: A Suite of Portable Game Libraries.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.5-rc1
$(PKG)_CHECKSUM := d421a3c84517b4bfc8c6402887c74984ec57c12bc85f2dc2729de3ec4cdcdbe4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc mesa

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://sourceforge.net/projects/plib/files/plib/" | \
    grep 'plib/files/plib' | \
    $(SED) -n 's,.*plib/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # coding discipline...
    $(SED) -i '$(1)/src/net/netChat.cxx' \
        -e 's#char\* ptr = strstr#const &#g'
    $(SED) -i '$(1)/src/ssg/ssgLoadMDL_BGLTexture.cxx' \
        -e 's#char \*p = strrchr#char *p = (char*)strrchr#g'
    $(SED) -i '$(1)/src/ssg/ssgSaveAC.cxx' \
        -e 's#char *\* *s#const &#g'

    $(SED) -i '$(1)/src/ssg/ssgParser.cxx' \
        -e 's#= "EO#= (char*)"EO#' \
        -e 's#return strchr#return (char*)strchr#'

    $(SED) -e 's#char *\* *indent = ""#const &#g' -i \
        '$(1)/src/ssg/ssgLoadVRML.h' \
        '$(1)/src/ssg/ssgLoaderWriterStuff.h' \
        '$(1)/src/ssg/ssgOptimiser.cxx' \
        '$(1)/src/ssg/ssg.h'
    $(SED) -e 's#char *\* *in*dent,#const &#g' -i \
        `find $(1)/src/ssg -name 'ssg*.cxx'`

    cd '$(1)' && autoreconf -fi

    $(SED) -i '$(1)/ltmain.sh' \
        -e 's#allow_undefined=yes#allow_undefined=no#'

    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        LDFLAGS="`$(TARGET)-pkg-config mesa --libs`" \
        PKG_CONFIG='$(TARGET)-pkg-config'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install --keep-going \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        html_DATA= \
        CXXFLAGS='-Wno-overloaded-virtual' \
        LDFLAGS='`$(MXE_INTRINSIC_SH) aeabi_{,u}idivmod.S.obj {,u}divmodsi4.S.obj floatdidf.c.obj chkstk.S.obj`' \
        AR='$(TARGET)-ar'
endef
