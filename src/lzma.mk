# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lzma
$(PKG)_WEBSITE  := https://www.7-zip.org/sdk.html
$(PKG)_DESCR    := LZMA SDK
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2201
$(PKG)_CHECKSUM := 35b1689169efbc7c3c147387e5495130f371b4bad8ec24f049d28e126d52d9fe
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := lzma$(subst .,,$($(PKG)_VERSION)).7z
$(PKG)_URL      := https://www.7-zip.org/a/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.7-zip.org/sdk.html' | \
    $(SED) -n 's,.*lzma\([0-9][^"]*\)\.7z.*,\1,p' | \
    head -1
endef

# liblzma is actually installed by xz
# https://github.com/mxe/mxe/issues/1481
define $(PKG)_BUILD
    # lowercase file names on case-sensitive file systems
    $(SED) -i 's#lOle32#lole32#' '$(SOURCE_DIR)/C/7zip_gcc_c.mak'

    # disable CRC32 instructions available since armv8/aarch64
    $(SED) -i 's#MY_CPU_ARM_OR_ARM64#MY_CPU_ARM64#' '$(SOURCE_DIR)/C/7zCrc.c'

    $(MAKE) all -C '$(1)/C/Util/Lzma' \
        -f makefile.gcc -j '$(JOBS)' \
        'IS_MINGW=1' \
        'PROG=lzma.exe' \
        'CC=$(TARGET)-gcc' \
        'CXX=$(TARGET)-g++' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'WINDRES=$(TARGET)-windres' \
        'PKG_CONFIG=$(TARGET)-pkg-config' \
        'LDFLAGS=-Wl,--allow-multiple-definition -L$(TARGET)/lib'
    cp '$(1)/bin/lzma.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma.exe'
    $(MAKE) all -C '$(1)/CPP/7zip/Bundles/LzmaCon' \
        -f makefile.gcc -j '$(JOBS)' \
        'IS_MINGW=1' \
        'PROG=lzma.exe' \
        'CXX=$(TARGET)-g++ -O2 -Wall -Wno-missing-exception-spec' \
        'CXX_C=$(TARGET)-gcc -O2 -Wall' \
        'CC=$(TARGET)-gcc' \
        'LD=$(TARGET)-ld' \
        'AR=$(TARGET)-ar' \
        'WINDRES=$(TARGET)-windres' \
        'PKG_CONFIG=$(TARGET)-pkg-config' \
        'LDFLAGS=-Wl,--allow-multiple-definition -L$(TARGET)/lib'
    cp '$(1)/CPP/7zip/Bundles/LzmaCon/_o/lzma.exe.exe' \
        '$(PREFIX)/$(TARGET)/bin/lzma-cxx.exe'
endef

$(PKG)_BUILD_$(BUILD) :=
