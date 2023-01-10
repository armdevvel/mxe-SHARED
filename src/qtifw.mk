# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtifw
$(PKG)_WEBSITE  := https://doc.qt.io/qtinstallerframework/index.html
$(PKG)_DESCR    := Qt Installer Framework
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5.1
$(PKG)_CHECKSUM := 602417a0a2ada5cada8f5b6ad5a160390198b68b46a3721022b7370a971b040a
$(PKG)_SUBDIR   := installer-framework-opensource-src-4.5
$(PKG)_FILE     := installer-framework-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/official_releases/qt-installer-framework/$($(PKG)_VERSION)/installer-framework-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := cc qtbase qttools
$(PKG)_DEPS_STATIC   := $($(PKG)_DEPS_$(BUILD)) qtwinextras $(BUILD)~$(PKG)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://download.qt.io/official_releases/qt-installer-framework/' | \
    $(SED) -n 's,.*<a href="*\([0-9][^"]*\)/.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && $(TARGET)-qmake-qt5 '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(INSTALL) -m755 '$(BUILD_DIR)/bin/binarycreator' '$(PREFIX)/bin/$(TARGET)-binarycreator'
    $(INSTALL) -m755 '$(BUILD_DIR)/bin/repogen' '$(PREFIX)/bin/$(TARGET)-repogen'
    $(INSTALL) -m755 '$(BUILD_DIR)/bin/archivegen' '$(PREFIX)/bin/$(TARGET)-archivegen'
    $(INSTALL) -m755 '$(BUILD_DIR)/bin/devtool' '$(PREFIX)/bin/$(TARGET)-devtool'
endef

# only makes sense for static builds
define $(PKG)_BUILD_STATIC
    # *.rc file has strange encoding issues with macro
    $(SED) -i 's,IFW_VERSION_STR_WIN32,"$($(PKG)_VERSION)",g' '$(SOURCE_DIR)/src/sdk/installerbase.rc'
    cd '$(BUILD_DIR)' && $(TARGET)-qmake-qt5 '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j  1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # build the tutorial installer in /tmp, because the binarycreator internal
    # rename will fail if /tmp is not in the same filesystem as mxe
    cd '$(SOURCE_DIR)/examples/tutorial' && \
    '$(PREFIX)/bin/$(BUILD)-binarycreator' \
        -c config/config.xml \
        -p packages \
        -t '$(PREFIX)/$(TARGET)/qt5/bin/installerbase.exe' \
        '/tmp/test-$(PKG)-tutorialinstaller.exe' && \
    rm -rf '$(PREFIX)/$(TARGET)/bin/test-$(PKG)-tutorialinstaller.exe'* && \
    mv -fv '/tmp/test-$(PKG)-tutorialinstaller.exe'* '$(PREFIX)/$(TARGET)/bin/'
endef
