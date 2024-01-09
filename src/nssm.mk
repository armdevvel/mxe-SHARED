# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nssm
$(PKG)_WEBSITE  := https://nssm.cc/
$(PKG)_DESCR    := NSSM - the New Simple Service Manager
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.101-2
$(PKG)_CHECKSUM := 341d93d05e62535384da1a9e76b72fce208514e2669b6c6c8620c9962d28a6d3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_GH_CONF  := treeswift/nssm/tags
$(PKG)_DEPS     := cc meson-wrapper $(BUILD)~wine-tools

# Note (from the original documentation):
# 2017-04-26: Users of Windows 10 Creators Update or newer should use prelease build 2.24-101 
# or any newer build to avoid an issue with services failing to start. If for some reason you
# cannot use that build you can alternatively set AppNoConsole=1 in the registry, noting that
# applications which expect a console window may behave unexpectedly.
#
# (Neither Rita nor Lima are affected, but since Windows for AArch64 is our legitimate target
#  as well, it seems reasonable to accommodate the recent changes. -- @treeswift)

# Note on the manual steps prior to Meson/Ninja project generation:
# until we have RC support in target Meson config, *.[mr]c are compiled and injected manually.

# 3rd version number field increment to 2.24.101-0 stands for the 2017 pre-release;
# 4th version number field increment to 2.24.101-2 stands for our 2023 MinGW fixes.

define $(PKG)_BUILD
    # -DV* substitute definitions from the (missing) VS_FIXEDFILEINFO structure (verrsrc.h)
    # add --verbose to debug resource parsing (off by default as it hexdumps binary output)

    cd '$(SOURCE_DIR)' \
    && ( \
        echo '#define NSSM_VERSION _T("$($(PKG)_VERSION)")'; \
        echo '#define NSSM_VERSIONINFO 2,24,101,1'; \
        echo '#define NSSM_DATE _T("2017-05-16")'; \
        echo '#define NSSM_FILEFLAGS 0L'; \
        echo '#define NSSM_COPYRIGHT _T("Public Domain; Author Iain Patterson 2003-2017")' \
    ) > version.h \
    && '$(wine_TOOLDIR)/wmc' -u -U messages.mc \
    && iconv -f utf-16 -t utf-8 nssm.rc > nssm8.rc \
    && '$(wine_TOOLDIR)/wrc' nssm8.rc '--include-dir=$(PREFIX)/$(TARGET)/include' -D_INC_VADEFS \
        -DVS_FF_DEBUG=0 \
        -DVS_FF_PRERELEASE=0 \
        -DVOS__WINDOWS32=0x4L \
        -DVFT_APP=0x1L \
        -o nssmwrc.res -O res \
    && 'llvm-cvtres' nssmwrc.res /VERBOSE /MACHINE:ARM /OUT:nssmwrc.o \
    && meson init --force '--name=$(PKG)' '--version=$($(PKG)_VERSION)'

    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) '$(BUILD_DIR)' '$(SOURCE_DIR)'
    $(SED) -i 's!-Wall!-Wall -Wno-writable-strings -Wno-unused-parameter!g' \
        '$(BUILD_DIR)/build.ninja'
    $(SED) -i 's!-Wl,--end-group!-lshlwapi -lpsapi -Wl,--end-group -Wl,-export-all-symbols $(SOURCE_DIR)/nssmwrc.o!' \
        '$(BUILD_DIR)/build.ninja'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
