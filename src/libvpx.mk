# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libvpx
$(PKG)_WEBSITE  := https://www.webmproject.org/code/
$(PKG)_DESCR    := vpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.2
$(PKG)_CHECKSUM := 26fcd3db88045dee380e581862a6ef106f49b74b6396ee95c2993a260b4636aa
$(PKG)_GH_CONF  := webmproject/libvpx/tags,v
$(PKG)_DEPS     := cc pthreads yasm

define $(PKG)_BUILD
    $(SED) -i 's,yasm[ $$],$(TARGET)-yasm ,g' '$(1)/build/make/configure.sh'
    cd '$(1)' && \
        CROSS='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --target=@libvpx-target@ \
        --disable-examples \
        --disable-install-docs \
        --as=$(TARGET)-yasm \
        --disable-runtime-cpu-detect
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(TARGET)-ranlib $(PREFIX)/$(TARGET)/lib/libvpx.a
endef

$(PKG)_BUILD_armv7-w64-mingw32       = $(subst @libvpx-target@,armv7-win32-gcc,$($(PKG)_BUILD))
$(PKG)_BUILD_armv7-w64-mingw32.debug = $(subst @libvpx-target@,armv7-win32-gcc,$($(PKG)_BUILD))
