PKG             := osslsigncode
$(PKG)_WEBSITE  := https://github.com/treeswift/$(PKG)
$(PKG)_DESCR    := OpenSSL based Authenticode signing for PE/MSI/Java CAB files.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5-cmd
$(PKG)_CHECKSUM := eeb9d2651fda72b88dabccc3f1291a335c45584de3ae7303710ccc7ff4d228dc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := openssl curl
$(PKG)_DEPS_$(BUILD) := openssl faketime popen2
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD_$(BUILD)
    cd $(BUILD_DIR) && $(TARGET)-cmake \
        -DCMAKE_PREFIX_PATH='$(PREFIX)/$(TARGET)' \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)' \
        -DCMAKE_OBJDUMP='$(TARGET)-objdump' \
        -S $(SOURCE_DIR) \
    && make -C '$(BUILD_DIR)' \
        install
endef
