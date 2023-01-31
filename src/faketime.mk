PKG             := faketime
$(PKG)_WEBSITE  := https://github.com/wolfcw/lib$(PKG)
$(PKG)_DESCR    := Running programs with customized system time
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.10
$(PKG)_CHECKSUM := 729ad33b9c750a50d9c68e97b90499680a74afd1568d859c574c0fe56fe7947f
$(PKG)_SUBDIR   := lib$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := $($(PKG)_WEBSITE)/archive/refs/tags/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    cd $(SOURCE_DIR) && $(MAKE) \
        PREFIX='$(PREFIX)/$(TARGET)' \
        install
endef
