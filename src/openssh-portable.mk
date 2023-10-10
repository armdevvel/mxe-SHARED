# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openssh-portable
$(PKG)_WEBSITE  := https://www.openssh.com/
$(PKG)_DESCR    := Portable OpenSSH (BSD or freer)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.4.0.1-rakko
$(PKG)_CHECKSUM := 15b71c3c735f588908cc297fbae54978db52530399a897fb72c6c48848a02133
$(PKG)_GH_CONF  := armdevvel/openssh-portable/tags, v
$(PKG)_DEPS     := cc openssl zlib meson-wrapper $(BUILD)~wine-tools

define $(PKG)_BUILD
    # https://devblogs.microsoft.com/commandline/af_unix-comes-to-windows/
    # -- Unix sockets since Insider Build 17063

    # Parent fork depends on:
    # LibreSSL: https://github.com/PowerShell/LibreSSL/releases/download/3.7.3.0/LibreSSL.zip
    # LibFIDO: https://github.com/PowerShell/libfido2/releases/download/1.13.0/libfido2.zip
    # zlib 1.3 or greater
    
    # libfido2 is used to interact with hardware security devices via USB or NFC.
    # We currently consider this use case marginal and unlikely. Hardware-backed
    # security can be reenabled with #define ENABLE_SK_INTERNAL 1 in config.h.vs
    # (also uncomment the definition of `ssh-sk-helper` in top-level meson.build)

    # *** sizzling WIP. *DONTMERGE* until the configuration directory layout is sorted out,
    # all the supplementary configuration file templates and support scripts are installed;
    # also, it is advised to extract win32iocompat as a convenient compatibility layer. ***

    '$(wine_TOOLDIR)/wrc' '$(SOURCE_DIR)/contrib/win32/openssh/version.rc' \
        '--include-dir=$(PREFIX)/$(TARGET)/include' -D_INC_VADEFS \
        -o '$(BUILD_DIR)/version.res' -O res \
    && 'llvm-cvtres' '$(BUILD_DIR)/version.res' /VERBOSE /MACHINE:ARM '/OUT:$(BUILD_DIR)/version.o'

    '$(wine_TOOLDIR)/wrc' '$(SOURCE_DIR)/contrib/win32/openssh/openssh-events.rc' \
        '--include-dir=$(PREFIX)/$(TARGET)/include' -D_INC_VADEFS \
        -o '$(BUILD_DIR)/agent-events.res' -O res \
    && 'llvm-cvtres' '$(BUILD_DIR)/agent-events.res' /VERBOSE /MACHINE:ARM '/OUT:$(BUILD_DIR)/agent-events.o'

    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
