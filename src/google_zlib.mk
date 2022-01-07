# This file is part of MXE. See LICENSE.md for licensing information.

PKG				:= google_zlib
$(PKG)_WEBSITE  := https://chromium.googlesource.com/chromium/src/third_party/zlib
$(PKG)_DESCR	:= Google-maintained version of ZLib (a dependency of Chromium)
$(PKG)_VERSION  := 09490503d0f201b81e03f5ca0ab8ba8ee76d4a8e
$(PKG)_CHECKSUM := d5389a4c312f6cef97c1be9ad86e2ee02920da97f5dc579a982eff1164f0235b
$(PKG)_SUBDIR	:= $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE		:= $($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= https://github.com/kniefliu/zlib/archive/$($(PKG)_FILE)

# The below build actions have been contributed by Kai Pastor and released under the following license:
#
# Copyright (c) Microsoft Corporation
# 
# All rights reserved. 
# 
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

define $(PKG)_BUILD
	cp '$(PKG_DIR)/$($(PKG)_FILE)' '$(PWD)/resources/$(PKG)-0949050.tar.gz' \
	&& echo Successfully installed Google ZLib for reuse by other packages. 
endef
