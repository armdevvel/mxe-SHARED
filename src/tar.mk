# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := tar
$(PKG)_DESCR    := Tape archiver
$(PKG)_IGNORE   :=
$(PKG)_WEBSITE  := https://www.gnu.org/software/tar/
$(PKG)_VERSION  := 1.34
$(PKG)_CHECKSUM := 03d908cf5768cfe6b7ad588c921c6ed21acabfb2b79b788d1330453507647aed
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
# NOTE: see https://bug-tar.gnu.narkive.com/uIjx0Inr/need-to-build-a-windows-tar

# other possible backends include 'compress', 'lzip', 'lzop'
$(PKG)_DEPS     := cc bzip2 gzip lzma xz zstd zlib glob libwusers

# Before we surrender to -DMSDOS=1, here is the remaining unresolved symbols list:
# - fork, waitpid and (though not technically symbols) wait status testing macros.
#
#   Equivalent Windows code exists; however, I would be reluctant to use it in tar
#   because of the GPL lock-in, and I would be reluctant to release it as a shared
#   library until it is sufficiently mature. The fork-pipe-wait "*nix way" demands
#   much more than a few system calls mapped to each other because they are "kinda
#   equivalent". Current patches, for example, remove all SIGPIPE dependent code.
#
# Until these issues are ironed out, the current build does not support compressed
# or remote archives. Fortunately, however menial its use cases become, they will,
# at least, stay forward-compatible once a functional shell is ported and *nix way
# process composition is finally available. Patches are broken down into long-term
# "fixes" and short-term "hacks".
#
# Better (both license-wise and portability-wise) TAR implementations *DO* exist -
# if we are ready for fine tuning of their command line switches.
#
# KNOWN: libtar builds statically as libtar.a (not a big loss due to GPL, though).

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I $(PREFIX)/$(TARGET)/share/aclocal
    cd '$(1)' && ./configure \
        --enable-backup-scripts \
        $(MXE_CONFIGURE_OPTS) \
        "CFLAGS=-DMSDOS=1" \
    && $(MAKE) \
        LDFLAGS='$(PREFIX)/$(TARGET)/lib/glob.o -lwusers -lbcrypt -lws2_32 -lssp' \
        -j '$(JOBS)' \
        install
endef
