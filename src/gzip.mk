# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gzip
$(PKG)_WEBSITE  := https://www.gnu.org/software/gzip/
$(PKG)_DESCR    := GNU Zip compressor
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12
$(PKG)_CHECKSUM := 5b4fb14d38314e09f2fc8a1c510e7cd540a3ea0e3eb9b0420046b82c3bf41085
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)

$(PKG)_DEPS     := cc

# NOTE -lssp (GCC support library) is needed for __strcpy_chk, __strcat_chk
# MOREINFO shouldn't it be linked in by default?

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
    && $(MAKE) \
        -j '$(JOBS)' \
        LDFLAGS=-lssp \
        install
endef
