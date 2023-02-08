PKG             := glob
$(PKG)_WEBSITE  := https://man.openbsd.org/glob.3
$(PKG)_DESCR    := globbing (wildcard file search and iteration) -- BSD license
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2
$(PKG)_CHECKSUM := 164b86fc3ba1cd08d8162b8ace15154f9388583aae3d52d2bd5e78134607ed51
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/treeswift/$(PKG)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libwusers

# Notes:
# - user list expansion is not (sup)ported as of 1.0.1 - once ported, define HAS_PWD_H;
# - lstat() is hardwired to be stat() since Windows RT does not support symbolic links;
# - in the only occurrence of strlcpy() - copy to buf[] - strncpy() can be used instead

# TODOs:
# - library metadata (*.lo)
# - package metadata (*.pc)

define $(PKG)_BUILD
    $(TARGET)-gcc '$(SOURCE_DIR)/glob.c' -c \
        -isystem '$(SOURCE_DIR)' \
        '-Du_char=unsigned char' \
        '-Du_short=unsigned short' \
        '-Du_int=unsigned int' \
        '-Dlstat=stat' \
        '-DS_ISLNK(m)=0' \
        '-DHAS_PWD_H' \
        '-Dstrlcpy=strncpy' \
        -o '$(BUILD_DIR)/glob.o'
    $(INSTALL) -m 644 '$(SOURCE_DIR)/charclass.h' \
        '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m 644 '$(SOURCE_DIR)/glob.h' \
        '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m 644 '$(BUILD_DIR)/glob.o' \
        '$(PREFIX)/$(TARGET)/lib/'
endef
