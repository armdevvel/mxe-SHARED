# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := drmingw
$(PKG)_WEBSITE  := https://github.com/jrfonseca/drmingw
$(PKG)_DESCR    := Postmortem debugging tools for MinGW
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.11-arm32.001
$(PKG)_CHECKSUM := 860fed3c5ca72a014d3b47644b8aaed675b43ebe936d4c148fe752a7e2991d41
$(PKG)_GH_CONF  := armdevvel/drmingw/tags,
$(PKG)_DEPS     := cc libdwarf-0-3-4 zlib

define $(PKG)_BUILD
    # use distro-integrated library versions instead of resolving Git submodules
    # $(SED) -i 's!include (libdwarf.cmake)!find_package(libdwarf CONFIG REQUIRED)!' \
    #     '$(SOURCE_DIR)/thirdparty/CMakeLists.txt'
    $(SED) -i 's!include (zlib.cmake)!add_library(zlib SHARED IMPORTED)\nfind_library(ZLIB_PATH z HINTS "$${ZLIB_HINT}")\nset_target_properties(zlib PROPERTIES IMPORTED_LOCATION "$(ZLIB_PATH)")!' \
        '$(SOURCE_DIR)/thirdparty/CMakeLists.txt'
    $(call PREPARE_PKG_SOURCE,libdwarf-0-3-4,'$(SOURCE_DIR)/thirdparty/')
    (rmdir '$(SOURCE_DIR)/thirdparty/libdwarf' || true) && ln -sf './$(libdwarf-0-3-4_SUBDIR)' '$(SOURCE_DIR)/thirdparty/libdwarf'

    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DZLIB_HINT:String=$(PREFIX)/$(TARGET)/lib

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # NOTE: run "catchsegv <your-app>" to write the crash dump into console;
    #       can be passed via DEPLOY_EXE to tools/ci.sh
    # NOTE: you need the following flags to generate meaningful stack dumps:
    #       -g -gdwarf-aranges -fno-omit-frame-pointer
endef
