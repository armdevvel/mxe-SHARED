# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jack
$(PKG)_WEBSITE  := https://jackaudio.org/
$(PKG)_DESCR    := JACK Audio Connection Kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1795946
$(PKG)_CHECKSUM := b0ba52bfdce5c9eaae35f73c6f45fc2cdea8d75bcaf310b4186ea1a5756a63b7
$(PKG)_GH_CONF  := jackaudio/jack2/branches/develop
$(PKG)_DEPS     := cc libgnurx libsamplerate portaudio pthreads

define $(PKG)_BUILD
    # uses modified waf so can't use MXE waf package
    cd '$(SOURCE_DIR)' && \
        AR='$(TARGET)-ar' \
        CC='$(TARGET)-gcc' \
        CXX='$(TARGET)-g++' \
        PKGCONFIG='$(TARGET)-pkg-config' \
        ./waf configure build install \
            -j '$(JOBS)' \
            --prefix='$(PREFIX)/$(TARGET)' \
            --platform=win32
endef
