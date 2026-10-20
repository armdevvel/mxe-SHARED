# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mesa
$(PKG)_WEBSITE  := https://mesa3d.org
$(PKG)_DESCR    := The Mesa 3D Graphics Library
$(PKG)_VERSION  := 23.1.7
$(PKG)_DEPS     := mesa-gl mesa-glu
$(PKG)_OO_DEPS   = pkgconf
$(PKG)_TYPE     := meta
