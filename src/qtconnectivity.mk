# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtconnectivity
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 0380327871f76103e5b8c2a305988d76d352b6a982b3e7b3bc3cdc184c64bfa0
$(PKG)_SUBDIR    = $(subst qtbase,qtconnectivity,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtconnectivity,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtconnectivity,$(qtbase_URL))
$(PKG)_DEPS     := cc qtbase qtdeclarative

$(PKG)_BTHPROPS := /mnt/c/Program Files (x86)/Windows Kits/10/Lib/10.0.10240.0/um/arm/bthprops.lib

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    # Need bthrpos.lib -- if we are on WSL, obtain it automatically.
    ls '$(PREFIX)/$(TARGET)/lib/bthprops.lib' \
        || $(INSTALL) -m 644 '$($(PKG)_BTHPROPS)' '$(PREFIX)/$(TARGET)/lib' \
        || (echo "Please copy or symlink bthprops.lib from Windows 10 SDK into $(PREFIX)/$(TARGET)/lib" && false)

    cd '$(1)' && '$(PREFIX)/$(TARGET)/qt5/bin/qmake'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
