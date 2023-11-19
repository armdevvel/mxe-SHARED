# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := hdf5
$(PKG)_WEBSITE  := https://www.hdfgroup.org/hdf5/
$(PKG)_DESCR    := HDF5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.12
$(PKG)_CHECKSUM := 6d080f913a226a3ce390a11d9b571b2d5866581a2aa4434c398cd371c7063639
$(PKG)_SUBDIR   := hdf5-$($(PKG)_VERSION)
$(PKG)_FILE     := hdf5-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-$(call SHORT_PKG_VERSION,$(PKG))/hdf5-$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.hdfgroup.org/ftp/HDF5/current/src/' | \
    grep '<a href.*hdf5.*bz2' | \
    $(SED) -n 's,.*hdf5-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_H5_CFGAGENT := H5Agent
$(PKG)_AGENT_TOOLS := H5detect.exe H5make_libsettings.exe libhdf5.settings
$(PKG)_AGENT_BATCH := hdf5-cfg.bat
$(PKG)_AGENT_FILES := $($(PKG)_AGENT_TOOLS) $($(PKG)_AGENT_BATCH)
$(PKG)_AGENT_LOCAL = $(PREFIX)/$(TARGET)/bin/$($(PKG)_H5_CFGAGENT)
$(PKG)_TEST_DEVICE := $${DEPLOY_NET:-user@HOST}
$(PKG)_AGENT_INTEL := H5lib_settings.c H5Tinit.c
$(PKG)_FILED_UNDER := mxe-generated-sources/

define $(PKG)_BUILD
    # HDF5 needs some information that it prefers to collect on the target device itself.
    # We first check availability of device-originated files under $($(PKG)_FILED_UNDER).
    # Then, if device-specific generated files are not available, we build the generator
    # and leave the operator (you) instructions how to run it on the device.
    # If the target device has no sshd running, perform the equivalent actions manually.

    cp '$(1)/$($(PKG)_FILED_UNDER)/$(word 1,$(subst ., ,$(TARGET)))/'*.c '$(1)/src/' || ( \
    : automake 1.13 needs the following directory to exist;                                     \
    ( [ -d '$(1)/m4' ] || mkdir '$(1)/m4' );                                                    \
    cd '$(1)' && autoreconf --force --install;                                                  \
    cd '$(1)' && ./configure                                                                    \
        $(MXE_CONFIGURE_OPTS)                                                                   \
        --enable-cxx                                                                            \
        --disable-direct-vfd                                                                    \
        --with-pthread='$(PREFIX)'                                                              \
        --with-zlib='$(PREFIX)'                                                                 \
        AR='$(TARGET)-ar'                                                                       \
        CPPFLAGS='-DH5_HAVE_WIN32_API                                                           \
                -DH5_HAVE_MINGW                                                                 \
                -DHAVE_WINDOWS_PATH                                                             \
                  -DH5_BUILT_AS_$(if $(BUILD_STATIC),STATIC,DYNAMIC)_LIB';                      \
    : libtool is somehow created to effectively disallow shared builds;                         \
    $(SED) -i 's,allow_undefined_flag="unsupported",allow_undefined_flag="",g' '$(1)/libtool';  \
    $(INSTALL) -d $($(PKG)_AGENT_LOCAL);                                                        \
    for f in $($(PKG)_AGENT_TOOLS); do                                                          \
        $(MAKE)       -C '$(1)'/src $$f &&                                                      \
        $(PREFIX)/bin/selfsign.sh '$(1)'/src/$$f &&                                             \
        $(INSTALL) -m755 '$(1)'/src/$$f $($(PKG)_AGENT_LOCAL)/;                                 \
    done;                                                                                       \
    (echo 'mkdir $(TARGET)';                                                                    \
    echo 'H5detect.exe > $(TARGET)\H5Tinit.c';                                                  \
    echo 'H5make_libsettings.exe > $(TARGET)\H5lib_settings.c';)                                \
    > '$($(PKG)_AGENT_LOCAL)/$($(PKG)_AGENT_BATCH)';                                            \
    : generated sources are mostly tied to CPU and do not vary with static/shared;              \
    echo "---- 8< ---- 8< ---- 8< ---- 8< ---- 8< ---- 8< ---- 8< ----";                        \
    echo "1. Copy to target:                                                                    \
       scp -r usr/$(TARGET)/bin/$($(PKG)_H5_CFGAGENT) $($(PKG)_TEST_DEVICE):";                  \
    echo "2. Generate: ssh $($(PKG)_TEST_DEVICE)                                                \
        -C 'cmd /C \"cd $($(PKG)_H5_CFGAGENT) && $($(PKG)_AGENT_BATCH)\"'";                     \
    echo "3. Pull generated directory: scp -r                                                   \
        $($(PKG)_TEST_DEVICE):$($(PKG)_H5_CFGAGENT)/$(TARGET) ./";                              \
    echo "4. Add it to hdf5-2-platform-detection.patch under $($(PKG)_FILED_UNDER)";            \
    false ) # The buck stops here, as we have left complete manual instructions to the operator.

    for d in src c++/src hl/src hl/c++/src; do \
        $(MAKE) -C '$(1)'/$$d -j '$(JOBS)' && \
        $(MAKE) -C '$(1)'/$$d -j 1 install; \
    done

    # install prefixed wrapper scripts
    $(INSTALL) -m755 '$(1)'/tools/misc/h5cc '$(PREFIX)/bin/$(TARGET)-h5cc'
    $(INSTALL) -m755 '$(1)'/c++/src/h5c++   '$(PREFIX)/bin/$(TARGET)-h5c++'

    # setup cmake toolchain
    (echo 'set(HDF5_C_COMPILER_EXECUTABLE $(PREFIX)/bin/$(TARGET)-h5cc)'; \
     echo 'set(HDF5_CXX_COMPILER_EXECUTABLE $(PREFIX)/bin/$(TARGET)-h5c++)'; \
     ) > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires: zlib'; \
     echo 'Libs: -lhdf5_hl -lhdf5'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hdf5.exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`

    # test cmake can find hdf5
    mkdir '$(1).test-cmake'
    cd '$(1).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(1).test-cmake' -j 1 install VERBOSE=ON
endef
