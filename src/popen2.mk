PKG             := popen2
$(PKG)_WEBSITE  := https://iximiuz.com/en/posts/how-to-on-processes
$(PKG)_DESCR    := popen2 - duplex popen()
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := cadbd64be73af6e766e1649218b3a5a03b9f6efa
$(PKG)_CHECKSUM := 7d3ee01de47a87088dd00159b83804865c37a2c9313f78ae763495cb185a933f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/iximiuz/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_BUILD
    $(if $(BUILD_CROSS),'$(TARGET)-',)gcc $(if $(BUILD_CROSS),'','-fPIE') -c '$(SOURCE_DIR)/popen2.c' -o '$(BUILD_DIR)/popen2.o' \
        && '$(INSTALL)' -m 644 '$(BUILD_DIR)/popen2.o' '$(PREFIX)/$(TARGET)/lib' \
        && '$(INSTALL)' -m 644 '$(SOURCE_DIR)/popen2.h' '$(PREFIX)/$(TARGET)/include' \
        && $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig' \
        && (echo 'prefix=$(PREFIX)/$(TARGET)'; \
            echo 'exec_prefix=$${prefix}'; \
            echo 'libdir=$${exec_prefix}/lib'; \
            echo 'includedir=$${prefix}/include'; \
            echo ''; \
            echo 'Name: $(PKG)'; \
            echo 'Version: $($(PKG)_VERSION)'; \
            echo 'Description: duplex popen()'; \
            echo 'Libs: $${libdir}/popen2.o'; \
            echo 'Cflags: -I$${includedir}';) \
            > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

endef
