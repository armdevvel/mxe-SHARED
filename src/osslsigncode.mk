PKG             := osslsigncode
$(PKG)_WEBSITE  := https://github.com/mtrojnar/$(PKG)
$(PKG)_DESCR    := OpenSSL based Authenticode signing for PE/MSI/Java CAB files.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5
$(PKG)_CHECKSUM := 815a0e6dcc1cb327da0cbd22589269aae1191d278e3570cd6e4a7c12d9fabe92
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/releases/download/$($(PKG)_VERSION)/$($(PKG)_FILE)
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

    # -time 978307200 equivalent to 20010101000000Z
endef
