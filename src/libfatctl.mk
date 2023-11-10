# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libfatctl
$(PKG)_DESCR    := *nix fd API on Windows
$(PKG)_WEBSITE  := https://github.com/treeswift/$(PKG)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.0
$(PKG)_CHECKSUM := c03b74afa699202b5dc487672b01fa2f71c7ff7fcc407d369265f8fd615ac7e0
$(PKG)_GH_CONF  := treeswift/$(PKG)/tags,
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dfilesystem=std::__fs::filesystem \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
