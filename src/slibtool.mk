# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := slibtool
$(PKG)_WEBSITE  := https://dev.midipix.org/cross/slibtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.35
$(PKG)_CHECKSUM := aa8a4257bba2b0eb11cbdbd6e80b88a8926e05a796fa5bb4480d4e14941a2c6d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://dl.midipix.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    # "build, host, target"
    cd '$(1)' && MAKEFLAGS=--no-print-directory ./configure \
        --build=`cc -dumpmachine` \
        --host=`cc -dumpmachine` \
        --cchost=`cc -dumpmachine` \
        --target=`echo $(MXE_TRIPLETS) | cut -d ' ' -f 1` \
        --prefix=$(PREFIX)/$(BUILD) \
        --exec-prefix=$(PREFIX)/midipix

    $(MAKE) -C '$(1)' -j '$(JOBS)' all install
endef
