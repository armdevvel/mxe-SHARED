# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ffmpeg
$(PKG)_WEBSITE  := https://ffmpeg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.1.1
$(PKG)_CHECKSUM := 733984395e0dbbe5c046abda2dc49a5544e7e0e1e2366bba849222ae9e3a03b1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 gnutls lame libass libbluray libbs2b libcaca \
                   libvpx opencore-amr opus sdl2 speex theora vidstab \
                   vo-amrwbenc vorbis x264 x265 xvidcore yasm zlib

# DO NOT ADD fdk-aac OR openssl SUPPORT.
# Although they are free softwares, their licenses are not compatible with
# the GPL, and we'd like to enable GPL in our default ffmpeg build.
# See docs/index.html#potential-legal-issues

# PROJECT RAKKO (ROADMAP): we WOULD like to offer a sticky license-free distro.
# Therefore, the default option for Rita should be --disable-gpl.
# Component builds tainted with sticky licenses cannot be offered via official
# Rita installation channels. Installing such components must require a deliberate
# user action that is distinct from installing or updating Rita.
#
# If playing by these rules renders you uncomfortable, alternative solutions exist.
# If your Linux box has enough computing power, you can build desired components from
# source for your personal consumption without worrying about license compatibility.
# Alternatively, you can use the power of the four other boxes (soap, jury, ballot...)
# to convince the body politic that while commercial copyright is a sad and misguided
# compromise between excusable human need for reward and inexcusable human ignorance,
# sticky "copyleft" licenses are pure evil and abolishing them will help advance the
# legitimate interests of everyone while hurting the legitimate interests of no one.

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ffmpeg.org/releases/' | \
    $(SED) -n 's,.*ffmpeg-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha\|beta\|rc\|git' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --cross-prefix='$(TARGET)'- \
        --enable-cross-compile \
        --arch=$(firstword $(subst -, ,$(TARGET))) \
        --target-os=mingw32 \
        --prefix='$(PREFIX)/$(TARGET)' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared ) \
        --yasmexe='$(TARGET)-yasm' \
        $(if $(BUILD_RELEASE),--disable-debug) \
        --disable-pthreads \
        --enable-w32threads \
        --disable-doc \
        --enable-gpl \
        --enable-version3 \
        --extra-libs='-mconsole' \
        --enable-gnutls \
        --enable-libass \
        --enable-libbluray \
        --enable-libbs2b \
        --enable-libcaca \
        --enable-libmp3lame \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-libopus \
        --enable-libspeex \
        --enable-libtheora \
        --enable-libvidstab \
        --enable-libvo-amrwbenc \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libxvid \
        --extra-ldflags="-fstack-protector -lpthread" \
        $($(PKG)_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
