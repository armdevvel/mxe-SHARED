# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wine-tools
$(PKG)_WEBSITE  := http://simplesystems.org/libtiff/
$(PKG)_DESCR    := message (*.mc) compiler from Wine
$(PKG)_IGNORE   := $(wine_IGNORE)
$(PKG)_VERSION  := $(wine_VERSION)
$(PKG)_CHECKSUM := $(wine_CHECKSUM)
$(PKG)_SUBDIR   := $(wine_SUBDIR)
$(PKG)_FILE     := $(wine_FILE)
$(PKG)_URL      := $(wine_URL)
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := wine

# Wine configuration takes ages, but its tools are lightweight to build.
# We keep them in a single package and build slightly more than we need.
# The tools are linked statically and need no Wine-provided libraries --
# but watch for missing includes once actual projects start using them.

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,wine,'$(SOURCE_DIR)')
    cd '$(SOURCE_DIR)/$(wine_SUBDIR)' && ./configure \
        --prefix=$(wine_DESTDIR) \
        --disable-win16 \
        --disable-tests \
        --enable-win64
    $(MAKE) -C '$(SOURCE_DIR)/$(wine_SUBDIR)' -j '$(JOBS)' \
        tools/widl/install \
        tools/wmc/install \
        tools/wrc/install \
        nls/install

    #
    ################################
    ##         widl usage         ##
    ################################
    '$(wine_TOOLDIR)/widl' --help

    #
    ################################
    #           wmc usage         ##
    ################################
    '$(wine_TOOLDIR)/wmc' --help

    #
    ################################
    #           wrc usage         ##
    ################################
    '$(wine_TOOLDIR)/wrc' --help
endef
