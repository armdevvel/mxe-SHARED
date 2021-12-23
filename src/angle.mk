# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := angle
$(PKG)_WEBSITE  := https://chromium.googlesource.com/$(PKG)/$(PKG)
$(PKG)_DESCR    := ANGLE - Almost Native Graphics Layer Engine
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d15be77864e18f407c317be6f6bc06ee2b7d070a
# $(PKG)_VERSION  := chromium_4472
$(PKG)_CHECKSUM := 1f53a28a5206c821b246abec28535b128b1ce59e2f2f3147e238397e39ecb75d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/$($(PKG)_FILE)
# Nominal dependencies include egl-registry and opengl-registry but ANGLE provides the respective headers.
$(PKG)_DEPS     := cc google_zlib

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
	# Note: building with a gcc version less than 6.1 is not supported.
	# Note: $(PKG) currently requires the following libraries from the system package manager:
	# 	libx11-dev
	# 	libmesa-dev
	# 	libxi-dev
	# 	libxext-dev
	#
	# These can be installed on Ubuntu systems via:
	# 	apt-get install libx11-dev libmesa-dev libxi-dev libxext-dev.

	mkdir -p '$(SOURCE_DIR)/third_party/zlib' && cd '$(SOURCE_DIR)/third_party/zlib' \
		&& $(call UNPACK_ARCHIVE,$(PWD)/resources/google_zlib-0949050.tar.gz) --strip-components=1 \
		&& $(PATCH) -p1 -u < '$(PWD)/src/google-zlib-far-undef.patch' \
		&& cp '$(PWD)/src/angle-CMakeLists.txt' '$(SOURCE_DIR)/CMakeLists.txt' \
		&& cp '$(PWD)/src/angle_commit.h' '$(SOURCE_DIR)' \
		&& cp '$(PWD)/src/angle_commit.h' '$(SOURCE_DIR)/src/common' \
		&& cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
			-DDISABLE_INSTALL_HEADERS=0 \
			-DANGLE_IS_32_BIT_CPU=1 \
			-DBUILD_SHARED_LIBS=1
		
	$(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
	$(MAKE) -C '$(BUILD_DIR)' -j 1 install
	cp '$(SOURCE_DIR)/LICENSE' '$(PREFIX)/$(TARGET)/share/$(PKG)/copyright'
endef
