PKG             := harfbuzz
$(PKG)_WEBSITE  := https://wiki.freedesktop.org/www/Software/HarfBuzz/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.2
$(PKG)_CHECKSUM := e7e4041996a354f7772ee865e2658b4d008947f5d8464dbac310592a28666a98
$(PKG)_SUBDIR   := harfbuzz-$($(PKG)_VERSION)
$(PKG)_FILE     := harfbuzz-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/armdevvel/harfbuzz/releases/download/v2.7.2/harfbuzz-2.7.2.tar.gz
$(PKG)_DEPS     := cc cairo freetype-bootstrap glib icu4c

define $(PKG)_BUILD
    # mman-win32 is only a partial implementation
    cd '$(1)' && ./autogen.sh && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_header_sys_mman_h=no \
        CXXFLAGS='-std=c++11 -pthread -pthreads' \
        LDFLAGS='-pthread -pthreads' \
        LIBS='-lstdc++'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
