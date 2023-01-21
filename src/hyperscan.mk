# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hyperscan
$(PKG)_WEBSITE  := https://01.org/hyperscan
$(PKG)_DESCR    := Hyperscan
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 5.2.0-porting
$(PKG)_CHECKSUM := 62206d5ed8eff73e9c0e8b0ce49cec9b3a43878f655d7a46366c0a1aa9610871
$(PKG)_SUBDIR   := $(PKG)-rakko-2023
$(PKG)_FILE     := $($(PKG)_PROJECT_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/treeswift/$(PKG)/archive/refs/tags/rakko/2023.tar.gz
$(PKG)_DEPS     := cc boost $(BUILD)~ragel

# ARM support (discussion):
# https://github.com/intel/hyperscan/issues/197
#
# ARMv7 port (forked and tagged above):
# https://github.com/zzqcn/hyperscan
# 
# Aarch64 ports:
# https://github.com/kunpengcompute/hyperscan
# https://github.com/MarvellEmbeddedProcessors/hyperscan

# WindowsRT => ARM in Thumb mode
$(PKG)_ARCH_FLAGS = -march=thumb

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DRAGEL='$(PREFIX)/$(BUILD)/bin/ragel' \
        -DCMAKE_C_FLAGS="`$($(PKG)_ARCH_FLAGS)`" \
        -DCMAKE_CXX_FLAGS="`$($(PKG)_ARCH_FLAGS)`" \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        '$(1)/examples/simplegrep.c' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config --cflags --libs libhs`
endef
