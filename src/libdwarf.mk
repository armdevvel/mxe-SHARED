# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdwarf
$(PKG)_WEBSITE  := https://github.com/davea42/libdwarf-code
$(PKG)_DESCR    := Tools to access DWARF symbol and debugging information
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := 5cc5e97980fbe26832577d49061b2719b829ba72b97f30015670e4c2d0688906
$(PKG)_GH_CONF  := davea42/libdwarf-code/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DHAVE_UNUSED_ATTRIBUTE:Bool=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

# 0.5.0 is the latest and greatest stable release as of now, Feb 2023.
# However, drmingw uses 0.3.4, which we integrate as a source package.
