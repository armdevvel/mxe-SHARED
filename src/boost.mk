# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := boost
$(PKG)_WEBSITE  := https://www.boost.org/
$(PKG)_DESCR    := Boost C++ Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.90.0
$(PKG)_CHECKSUM := 913ca43d49e93d1b158c9862009add1518a4c665e7853b349a6492d158b036d4
$(PKG)_SUBDIR   := boost-$($(PKG)_VERSION)
$(PKG)_FILE     := boost-$($(PKG)_VERSION)-cmake.tar.gz
$(PKG)_URL      := https://github.com/boostorg/boost/releases/download/boost-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc bzip2 expat zlib

$(PKG)_DEPS_$(BUILD) := zlib

$(PKG)_SUFFIX = -clang22-mt-a32-1_90

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.boost.org/users/download/' | \
    $(SED) -n 's,.*/release/\([0-9][^"/]*\)/.*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # old version appears to interfere
    rm -rf '$(PREFIX)/$(TARGET)/include/boost-1_90/'
    rm -f "$(PREFIX)/$(TARGET)/lib/libboost"*

    # use cmake because we're AWESOME.
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)'

    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'

    # test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++11 \
        '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -I'$(PREFIX)/$(TARGET)/include/boost-1_90' \
        -lboost_serialization$($(PKG)_SUFFIX) \
        -lboost_thread$($(PKG)_SUFFIX) \
        -lboost_chrono$($(PKG)_SUFFIX) \
        -lboost_context$($(PKG)_SUFFIX)

# test cmake
    mkdir '$(BUILD_DIR).test-cmake'
    cd '$(BUILD_DIR).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install
endef
