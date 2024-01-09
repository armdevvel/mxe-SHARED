# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := putty
$(PKG)_WEBSITE  := https://www.chiark.greenend.org.uk/~sgtatham/putty/
$(PKG)_DESCR    := PuTTY: a free SSH and Telnet client
$(PKG)_VERSION  := 0.78
$(PKG)_CHECKSUM := 274e01bcac6bd155dfd647b2f18f791b4b17ff313753aa919fcae2e32d34614f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://the.earth.li/~sgtatham/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc perl

define $(PKG)_BUILD
    ## bulk-amend CMakeLists.txt scripts to produce distinct shared libraries
    ## commented out until circular dependencies are dealt with -- @treeswift
    # for cmakescript in `find '$(SOURCE_DIR)' -name CMakeLists.txt`; do \
    #     sed -i '/add_library/ s! STATIC! SHARED!g' "$$cmakescript"; \
    # done

    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)'
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --config Release --target preinstall
    
    ## now '$(BUILD_DIR)/shipped.txt' lists production-ready binaries (NOT tests)
    ## we also `find` libraries in '$(BUILD_DIR)' and includes in '$(SOURCE_DIR)'
    ## in order to componentize PuTTY for reuse (as its license allows it freely)

    # cd '$(SOURCE_DIR)' && ( find -name '*.h' | while read header \
    #     $(INSTALL) -m 644 -D "$$header" "$(PREFIX)/$(TARGET)/include/$(PKG)/$$header" \
    # done )
    # cd '$(BUILD_DIR)' && ( find -name 'lib*.a' | while read import \
    #     $(INSTALL) -m 644 -D "$$import" "$(PREFIX)/$(TARGET)/lib/$(PKG)/$$import" \
    # done )
    # cd '$(BUILD_DIR)' && ( find -name '*.dll' | while read shared; do \
    #     $(INSTALL) -m 644 -D "$$shared" "$(PREFIX)/$(TARGET)/bin/$(PKG)/$$shared" \
    # done )

    for binary in `cat '$(BUILD_DIR)/shipped.txt'`; do \
        $(INSTALL) -m 755 -D "$(BUILD_DIR)/$$binary" \
            "$(PREFIX)/$(TARGET)/bin/$(PKG)/$$binary"; \
    done
endef
