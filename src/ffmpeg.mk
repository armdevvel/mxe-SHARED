# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ffmpeg
$(PKG)_WEBSITE  := https://ffmpeg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.3
$(PKG)_CHECKSUM := 217eb211c33303b37c5521a5abe1f0140854d6810c6a6ee399456cc96356795e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ffmpeg.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 gnutls lame libass libbluray libbs2b libcaca \
                   libvpx opencore-amr opus sdl2 speex theora vidstab \
                   vo-amrwbenc vorbis x264 xvidcore yasm zlib

# FROM UPSTREAM MXE MAINTAINERS:
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
    # --enable-avisynth is Intel specific (examine!)

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
        --disable-debug \
        --disable-doc \
        --enable-avresample \
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
        --enable-libxvid \
        --extra-cflags="-D_WIN32_WINNT=0x0600" \
        --extra-ldflags="-fstack-protector -lpthread -lws2_32" \
        $($(PKG)_CONFIGURE_OPTS)

    # manual config.h hotfixing
    sed -i \
        -e 's!HAVE_WINSOCK2_H 0!HAVE_WINSOCK2_H 1!' \
        -e 's!HAVE_CLOSESOCKET 0!HAVE_CLOSESOCKET 1!' \
        -e 's!HAVE_STRUCT_POLLFD 0!HAVE_STRUCT_POLLFD 1!' \
        -e 's!HAVE_STRUCT_ADDRINFO 0!HAVE_STRUCT_ADDRINFO 1!' \
            '$(BUILD_DIR)/config.h'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' --keep-going
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
