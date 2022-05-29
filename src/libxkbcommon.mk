# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxkbcommon
$(PKG)_WEBSITE  := https://xkbcommon.org/
$(PKG)_DESCR    := Keymap handling library for toolkits and window systems 
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := 6fd58a0cdcc7702258adaeffb573a389228ae8f0eff47578efda2309b61b2ca6
$(PKG)_SUBDIR   := libxkbcommon-$($(PKG)_VERSION)
$(PKG)_FILE     := libxkbcommon-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://xkbcommon.org/download/libxkbcommon-1.4.1.tar.xz
$(PKG)_DEPS     := cc 

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && cp '$(PREFIX)/../cross.txt' .
    cd '$(SOURCE_DIR)' && meson --prefix '$(PREFIX)/$(TARGET)' --cross-file=cross.txt \
    -Denable-x11=false \
    -Denable-wayland=false \
    -Denable-docs=false \
    build

    
    cd '$(SOURCE_DIR)/build' && ninja -j '$(JOBS)' && meson install
endef