# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := perl-cross
$(PKG)_WEBSITE  := https://arsv.github.io/perl-cross/
$(PKG)_DESCR    := Cross-compiling perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := cc5acaab4defbcee7c107fd417d30412f3cdae5be8adf1fc22641485823b57ee
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/arsv/$(PKG)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_TYPE     := source-only

# perl-cross provides configure script, top-level Makefile and some auxiliary files for perl,
# with the primary emphasis on cross-compiling the source.
