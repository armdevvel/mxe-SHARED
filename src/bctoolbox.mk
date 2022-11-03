# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bctoolbox
$(PKG)_WEBSITE  := https://github.com/BelledonneCommunications/$(PKG)
$(PKG)_DESCR    := SIP toolbox by Belledonne Communications (GPL 3.0)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.67
$(PKG)_CHECKSUM := 3033899782fa92544f0b455818bf8b66661ce85a7dbb62553c28269f9c3a3e62
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc mbedtls bcunit decaf

# CMake struggles to find BcUnit by bcunit.pc/BcUnit.pc even though the case is correct
# Specifically, `find_package(BcUnit CONFIG REQUIRED)` arguments may be too restrictive
# Once that's fixed, remove `-DENABLE_TESTS_COMPONENT=Off` to re-enable the test suite.
# P.S. If case matters, either add a (gracefully failing)
#   ln -s '$(PREFIX)/$(TARGET)/lib/pkgconfig/bcunit.pc' \
#    	  '$(PREFIX)/$(TARGET)/lib/pkgconfig/BcUnit.pc' in bcunit.mk
# or fix the case in CMakeLists.txt

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
		-DENABLE_TESTS_COMPONENT=Off \
		-DENABLE_SHARED=$(CMAKE_SHARED_BOOL) \
		-DENABLE_STATIC=$(CMAKE_STATIC_BOOL) \
		'$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
