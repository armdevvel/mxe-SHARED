# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := toybox
$(PKG)_WEBSITE  := https://landley.net/toybox/
$(PKG)_DESCR    := Toybox: all-in-one Linux command line. Public domain.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.10-mingw-0.0.2
$(PKG)_CHECKSUM := 3bc4f6e020214b2655d1df43f27504e13c9dc6de84e283c4d2c95008e5fda4ab
$(PKG)_GH_CONF  := treeswift/toybox-mingw/tags
# TODO: (some part of) the hellish list of dependencies below will be moved to the 'libmoregw' meta-package
$(PKG)_DEPS     := cc libwusers libfatctl libmemmap ws2fwd pcre2 glob getline-compatible libob libprefix openssl zlib

$(PKG)_OUTNAME = $(PKG).exe
$(PKG)_OUTFILE = $($(PKG)_OUTNAME)
$(PKG)_DBGFILE = generated/unstripped/$($(PKG)_OUTNAME)

$(PKG)_MAKE = $(MAKE) -j '$(JOBS)' \
        CROSS_COMPILE='$(TARGET)-' \
        OUTNAME=$($(PKG)_OUTNAME)

# TODO: replace _DBGFILE with _OUTFILE in OUTFILE when we are relatively stable
define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' \
    && cp win32-config .config \
    && $($(PKG)_MAKE) oldconfig --keep-going \
    && $($(PKG)_MAKE) --keep-going \
    && env 'OUTFILE=$($(PKG)_DBGFILE)' env 'DBGFILE=$($(PKG)_DBGFILE)' env 'PREFIX=$(PREFIX)' env 'TARGET=$(TARGET)' scripts/winstall.sh
endef
