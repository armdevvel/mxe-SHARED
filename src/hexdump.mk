# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hexdump
$(PKG)_WEBSITE  := https://25thandclement.com/~william/projects/hexdump.c.html
$(PKG)_DESCR    := A slim reimplementation of the BSD hexdump(1). MIT license.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20181215
$(PKG)_CHECKSUM := 882975323317f595093125467d7b9604f78bded7ba1005f5fc17e33358cdb0fa
$(PKG)_GH_CONF  := wahern/hexdump/tags, rel-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' CC='$(TARGET)-gcc' '$(PKG)'
    $(INSTALL) -m644 '$(SOURCE_DIR)/$(PKG).exe' '$(PREFIX)/$(TARGET)/bin/'
endef
