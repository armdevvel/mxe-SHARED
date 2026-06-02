# This file is part of MXE. See LICENSE.md for licensing information.

# WIDL is called "Wine IDL Compiler"; but we use mingw-w64's copy of it to
# avoid downloading Wine's entire tree.

PKG             := widl
$(PKG)_WEBSITE  := https://www.winehq.org/docs/widl/
$(PKG)_DESCR    := Wine IDL Compiler
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.0.0
$(PKG)_CHECKSUM := 6eaf921d9eb987d3820b364ea9775bc19b965ec81490b6fdd716526c28e1995c
$(PKG)_SUBDIR   := mingw-w64-v$($(PKG)_VERSION)
$(PKG)_FILE     := mingw-w64-v$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(PKG)-release/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_BUILD
    cd '$(1)/mingw-w64-tools/widl' && ./configure \
        --host='$(BUILD)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --target='$(TARGET)'
    $(MAKE) -C '$(1)/mingw-w64-tools/widl' -j '$(JOBS)' install

    # create cmake file
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    echo 'set(CMAKE_WIDL $(PREFIX)/bin/$(TARGET)-$(PKG) CACHE PATH "widl executable")' \
    > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef
