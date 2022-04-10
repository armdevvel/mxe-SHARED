# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fltk
$(PKG)_WEBSITE  := https://www.fltk.org/
$(PKG)_DESCR    := FLTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.5
$(PKG)_CHECKSUM := 8729b2a055f38c1636ba20f749de0853384c1d3e9d1a6b8d4d1305143e115702
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_MAJOR    := $(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := https://fltk.org/pub/fltk/$($(PKG)_MAJOR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.fltk.org/software.php' | \
    $(SED) -n 's,.*>fltk-\([0-9]\+\([\.\-][0-9]\+\)\+\)-source\.tar\.gz<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd $(BUILD_DIR) && mkdir build && cd build && '$(TARGET)'-cmake -DOPTION_BUILD_EXAMPLES=OFF $(SOURCE_DIR)
    $(MAKE) -C $(BUILD_DIR)/build -j '$(JOBS)'
    $(MAKE) -C $(BUILD_DIR)/build -j 1 install
endef
