# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebkit
$(PKG)_WEBSITE  := https://github.com/annulen/webkit
$(PKG)_DESCR    := QtWebKit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.13.1
$(PKG)_CHECKSUM := f688e039e2bdc06e2e46680f3ef57715e1b7d6ea69fd76899107605a8f371ea3
$(PKG)_SUBDIR   := qtwebkit-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := qtwebkit-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/armdevvel/mxe-storage/raw/master/libraries/qt/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libxml2 libxslt libwebp qtbase qtmultimedia qtquickcontrols \
                   qtsensors qtwebchannel sqlite

# Fedora's patch is used to fix a Ruby Annotation error in this build!
# https://src.fedoraproject.org/rpms/qt5-qtwebkit/raw/rawhide/f/webkit-offlineasm-warnings-ruby27.patch

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/qt5 \
        -DCMAKE_CXX_FLAGS='-fpermissive' \
        -DEGPF_DEPS='Qt5Core Qt5Gui Qt5Multimedia Qt5Widgets Qt5WebKit' \
        -DPORT=Qt \
        -DENABLE_GEOLOCATION=OFF \
        -DENABLE_MEDIA_SOURCE=ON \
        -DENABLE_OPENGL=OFF \
        -DENABLE_VIDEO=ON \
        -DENABLE_WEB_AUDIO=ON \
        -DENABLE_WEBKIT2=OFF \
        -DUSE_GSTREAMER=OFF \
        -DUSE_MEDIA_FOUNDATION=OFF \
        -DUSE_QT_MULTIMEDIA=ON \
        -DENABLE_JIT=OFF \
        -DENABLE_API_TESTS=OFF \
        -DENABLE_MINIBROWSER=OFF \
        -G Ninja
    $(SED) -i 's/-fno-keep-inline-dllexport/-liconv -lws2_32 -licuin -licuuc -licudt -llzma -lpthread -pthread -pthreads/g' '$(BUILD_DIR)/build.ninja'
    ninja -C '$(BUILD_DIR)' -j '$(JOBS)' || ninja -C '$(BUILD_DIR)' -j '$(JOBS)'
    ninja -C '$(BUILD_DIR)' install

    # build test manually
    # add $(BUILD_TYPE_SUFFIX) for debug builds - see qtbase.mk
    $(TARGET)-g++ \
        -W -Wall -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config Qt5WebKitWidgets --cflags --libs`

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\qt5\\bin;..\\qt5\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\qt5\\plugins\r\n'; \
     printf 'test-$(PKG).exe\r\n'; \
     printf 'cmd\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-$(PKG).bat'
endef
