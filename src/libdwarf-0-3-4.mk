# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libdwarf-0-3-4
$(PKG)_WEBSITE  := https://github.com/davea42/libdwarf-code
$(PKG)_DESCR    := Tools to access DWARF symbol and debugging information
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.4
$(PKG)_CHECKSUM := 72c5595f31815bed856d09ad344bf4aab8f3ac887e25e41ae6f3a3b27ce31353
$(PKG)_GH_CONF  := davea42/libdwarf-code/tags,v
$(PKG)_TYPE     := source-only

# 0.5.0 is the latest and greatest stable release as of now, Feb 2023.
# However, drmingw uses 0.3.4, which we integrate as a source package.
