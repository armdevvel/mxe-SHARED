# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := protobuf
$(PKG)_WEBSITE  := https://github.com/google/protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.9.0
$(PKG)_CHECKSUM := 2ee9dcec820352671eb83e081295ba43f7a4157181dad549024d7070d079cf65
$(PKG)_GH_CONF  := google/protobuf/tags,v
$(PKG)_DEPS     := cc googlemock googletest zlib $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := googlemock googletest libtool

define $(PKG)_BUILD
    $(call PREPARE_PKG_SOURCE,googlemock,$(SOURCE_DIR))
    cd '$(SOURCE_DIR)' && mv '$(googlemock_SUBDIR)' gmock
    $(call PREPARE_PKG_SOURCE,googletest,$(SOURCE_DIR))
    cd '$(SOURCE_DIR)' && mv '$(googletest_SUBDIR)' gmock/gtest
    cd '$(SOURCE_DIR)' && ./autogen.sh

    # Hack you libtool and huck you GNU for failing to accept a simple fix. (Jealosy for CLang?)
    # See analysis and discussion: https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27866
    sed -i 's#-L\* \x7c -R\* \x7c -l\*#& | *clang_rt*#' '$(SOURCE_DIR)/m4/libtool.m4'
    sed -i '$(SOURCE_DIR)/ltmain.sh' \
        -e 's#deplib is not portable!"#deplib is now allowed."; deplib="-XCCLinker -Wl,$$deplib"#' \
        -e 's#valid_a_lib=false#valid_a_lib=:#'
    # Note: this libtool patch eliminates the need for the MXE_INTRINSIC_SH fix.
    # Wiki: https://github.com/armdevvel/mxe-SHARED/wiki/ld.lld:-error:-undefined-symbol:-__chkstk-or-__rt__blahblah

    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)'/configure \
        $(MXE_CONFIGURE_OPTS) \
        $(if $(BUILD_CROSS), \
            --with-zlib \
            --with-protoc='$(PREFIX)/$(BUILD)/bin/protoc' \
        )
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(if $(BUILD_CROSS),
        '$(TARGET)-g++' \
            -W -Wall -Werror -ansi -pedantic -std=c++14 \
            '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-protobuf.exe' \
            `'$(TARGET)-pkg-config' protobuf --cflags --libs`
    )
endef
