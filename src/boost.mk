# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := boost
$(PKG)_WEBSITE  := https://www.boost.org/
$(PKG)_DESCR    := Boost C++ Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.80.0
$(PKG)_CHECKSUM := 1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := boost_$(subst .,_,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc bzip2 expat zlib

$(PKG)_DEPS_$(BUILD) := zlib

$(PKG)_SUFFIX = -mt-x$(if $(findstring x86_64,$(TARGET)),64,32)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.boost.org/users/download/' | \
    $(SED) -n 's,.*/release/\([0-9][^"/]*\)/.*,\1,p' | \
    grep -v beta | \
    head -1
endef

# From Boost documentation:
# ================================================================
# The only Boost libraries that must be built separately are:
#
# Boost.Chrono
# Boost.Context
# Boost.Filesystem
# Boost.GraphParallel
# Boost.IOStreams
# Boost.Locale
# Boost.Log (see build documentation)
# Boost.MPI
# Boost.ProgramOptions
# Boost.Python (see the Boost.Python build documentation before building and installing it)
# Boost.Regex
# Boost.Serialization
# Boost.Thread
# Boost.Timer
# Boost.Wave
#
# A few libraries have optional separately-compiled binaries:

# Boost.Graph also has a binary component that is only needed if you intend to parse GraphViz files.
# Boost.Math has binary components for the TR1 and C99 cmath functions.
# Boost.Random has a binary component which is only needed if you're using random_device.
# Boost.Test can be used in “header-only” or “separately compiled” mode, although separate compilation is recommended for serious use.
# Boost.Exception provides non-intrusive implementation of exception_ptr for 32-bit _MSC_VER==1310 and _MSC_VER==1400 which requires a separately-compiled binary. This is enabled by #define BOOST_ENABLE_NON_INTRUSIVE_EXCEPTION_PTR.
# Boost.System is header-only since Boost 1.69. A stub library is still built for compatibility, but linking to it is no longer necessary.
#
# Source: https://www.boost.org/doc/libs/1_80_0/more/getting_started/windows.html
# ================================================================

# NOTE we exclude coroutine and fiber as highly architecture specific
# NOTE serialization is included (as its absence causes build issues)
# NOTE we include thread (but not context), filesystem, iostreams, locale, regex,
# NOTE program_options and log as mostly harmless

$(PKG)_LIBRARIES := \
    chrono context graph_parallel mpi python timer wave \
    coroutine fiber exception

# NOTE upstream MXE already excludes mpi and python by default
$(PKG)_WITHOUT_LIBRARIES := $(foreach lib,$($(PKG)_LIBRARIES),'--without-$(lib)')

$(PKG)_WITH_LIBRARIES := $($(PKG)_WITHOUT_LIBRARIES)

# cross-build, see b2 options at:
# https://www.boost.org/build/doc/html/bbv2/overview/invocation.html
define $(PKG)_B2_CROSS_BUILD
    cd '$(SOURCE_DIR)' && ./tools/build/b2 \
        --ignore-site-config \
        --user-config=user-config.jam \
        abi=ms \
        address-model=$(BITS) \
        architecture=arm \
        binary-format=pe \
        link=$(if $(BUILD_STATIC),static,shared) \
        target-os=windows \
        threadapi=win32 \
        threading=multi \
        variant=release \
        toolset=gcc-mxe \
        --layout=tagged \
        --disable-icu \
        $($(PKG)_WITH_LIBRARIES) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        install
endef

# TODO build $($(PKG)_LIBRARIES) as separate packages
# TODO reenable test-boost.exe and move into a separate package ("boosttest")
# TODO add "<address-model>32 <architecture>arm <binary-format>pe <threading>multi <toolset>msvc"

define $(PKG)_BUILD
    # old version appears to interfere
    rm -rf '$(PREFIX)/$(TARGET)/include/boost/'
    rm -f "$(PREFIX)/$(TARGET)/lib/libboost"*

    # create user-config
    echo 'using gcc : mxe : $(TARGET)-g++ : <rc>$(TARGET)-windres <archiver>$(TARGET)-ar <ranlib>$(TARGET)-ranlib ;' > '$(SOURCE_DIR)/user-config.jam'

    # compile boost build (b2)
    cd '$(SOURCE_DIR)/tools/build/' && ./bootstrap.sh

    # retry if parallel build fails - NOTE: disabled; fail fast, don't waste time
    $($(PKG)_B2_CROSS_BUILD) -a -j '$(JOBS)' # || $($(PKG)_B2_CROSS_BUILD) -j '1'

    $(if $(BUILD_SHARED), \
        mv -fv '$(PREFIX)/$(TARGET)/lib/'libboost_*.dll '$(PREFIX)/$(TARGET)/bin/')

    # setup cmake toolchain
    echo 'set(Boost_THREADAPI "win32")' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    # '$(TARGET)-g++' \
    #     -W -Wall -Werror -ansi -pedantic -std=c++11 \
    #     '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-boost.exe' \
    #     -DBOOST_THREAD_USE_LIB \
    #     -lboost_serialization$($(PKG)_SUFFIX) \
    #     -lboost_thread$($(PKG)_SUFFIX) \
    #     -lboost_system$($(PKG)_SUFFIX) \
    #     -lboost_chrono$($(PKG)_SUFFIX) \
    #     -lboost_context$($(PKG)_SUFFIX)

    # # test cmake
    # mkdir '$(BUILD_DIR).test-cmake'
    # cd '$(BUILD_DIR).test-cmake' && '$(TARGET)-cmake' \
    #     -DPKG=$(PKG) \
    #     -DPKG_VERSION=$($(PKG)_VERSION) \
    #     '$(PWD)/src/cmake/test'
    # $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install
endef

define $(PKG)_BUILD_$(BUILD)
    # old version appears to interfere
    rm -rf '$(PREFIX)/$(TARGET)/include/boost/'
    rm -f "$(PREFIX)/$(TARGET)/lib/libboost"*

    # compile boost build (b2)
    cd '$(SOURCE_DIR)/tools/build/' && ./bootstrap.sh

    # minimal native build - for more features, replace:
    # --with-system \
    # --with-filesystem \
    #
    # with:
    # --without-mpi \
    # --without-python \

    cd '$(SOURCE_DIR)' && \
        $(if $(call seq,darwin,$(OS_SHORT_NAME)),PATH=/usr/bin:$$PATH) \
        ./tools/build/b2 \
            -a \
            -q \
            -j '$(JOBS)' \
            --ignore-site-config \
            variant=release \
            link=static \
            threading=multi \
            runtime-link=static \
            --disable-icu \
            --with-system \
            --with-filesystem \
            --build-dir='$(BUILD_DIR)' \
            --prefix='$(PREFIX)/$(TARGET)' \
            --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
            --libdir='$(PREFIX)/$(TARGET)/lib' \
            --includedir='$(PREFIX)/$(TARGET)/include' \
            install
endef
