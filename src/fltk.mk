# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := fltk
$(PKG)_WEBSITE  := https://www.fltk.org/
$(PKG)_DESCR    := FLTK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.8
$(PKG)_CHECKSUM := f3c1102b07eb0e7a50538f9fc9037c18387165bc70d4b626e94ab725b9d4d1bf
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
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DFLTK_BUILD_TEST=OFF \
        -DFLTK_BUILD_EXAMPLES=OFF \
        -DOPTION_BUILD_SHARED_LIBS=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    ln -sf '$(PREFIX)/$(TARGET)/bin/fltk-config' '$(PREFIX)/bin/$(TARGET)-fltk-config'

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -ansi \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-fltk.exe' \
        `$(TARGET)-fltk-config --cxxflags --ld$(if $(BUILD_STATIC),static)flags`
endef
