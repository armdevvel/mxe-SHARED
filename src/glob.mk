PKG             := glob
$(PKG)_WEBSITE  := https://man.openbsd.org/glob.3
$(PKG)_DESCR    := globbing (wildcard file search and iteration) -- BSD license
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := 29fdba6af79ffd0fbebe541ea2c96a4fe71e4777023212f1ce2b241b330f0cf7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/treeswift/$(PKG)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libwusers

# Provides:
# - glob()
# - fnmatch()

# Notes:
# - lstat() is hardwired to be stat() since Windows RT does not support symbolic links;
# - in the only occurrence of strlcpy() - copy to buf[] - strncpy() can be used instead

# TODOs:
# - library metadata (*.lo)
# - package metadata (*.pc)

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
         -Dc_link_args='-Wl,-lwusers' \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j 1 install
endef
