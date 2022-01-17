# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmysqlclient
$(PKG)_WEBSITE  := https://dev.mysql.com/downloads/connector/c/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.18
$(PKG)_CHECKSUM := 4cb39a315298eb243c25c53c184b3682b49c2a907a1d8432ba0620534806ade8
$(PKG)_SUBDIR   := mysql-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://cdn.mysql.com/archives/mysql-8.0/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl zlib protobuf lz4 libevent curl zstd

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dev.mysql.com/downloads/connector/c/' | \
    $(SED) -n 's,.*mysql-connector-c-\([0-9\.]\+\)-win.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # native build for tool comp_err
    # See https://bugs.mysql.com/bug.php?id=61340
    mkdir '$(1).native'
    cd '$(1).native' && cmake \
         '$(1)'
    $(MAKE) -C '$(1).native' -j '$(JOBS)' VERBOSE=1 comp_err comp_sql
    # cross-compilation
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' \
        -DIMPORT_COMP_ERR='$(1).native/ImportCompErr.cmake' \
        -DIMPORT_COMP_SQL='$(1).native/ImportCompSql.cmake' \
		-DIMPORT_UCA9DUMP='$(1).native/ImportUca9Dump.cmake' \
        -DIMPORT_CONF2SRC='$(1).native/ImportConf2Src.cmake' \
        -DHAVE_GCC_ATOMIC_BUILTINS=1 \
        -DDISABLE_SHARED=$(CMAKE_STATIC_BOOL) \
        -DWITHOUT_SERVER=ON \
        -DENABLE_DTRACE=OFF \
        -DWITH_ZLIB=system \
        -DWITH_SSL=system \
        -DWITH_BOOST=system \
        -DWITH_SYSTEM_LIBS=ON \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET) \
        '$(1)'

    # def file created by cmake creates link errors
    $(if $(findstring i686-w64-mingw32.shared,$(TARGET)),
        cp '$(PWD)/src/$(PKG).def' '$(1).build/libmysql/libmysql_exports.def')

    $(MAKE) -C '$(1).build' -j '$(JOBS)' VERBOSE=1 libmysql
    $(MAKE) -C '$(1).build/include'  -j 1 install VERBOSE=1
    $(MAKE) -C '$(1).build/libmysql' -j 1 install VERBOSE=1
    
    # issues with scripts/sys_schema/comp_sql
    # $(MAKE) -C '$(1).build/scripts'  -j 1 install VERBOSE=1

    # no easy way to configure location of dll
    -mv '$(PREFIX)/$(TARGET)/lib/$(PKG).dll' '$(PREFIX)/$(TARGET)/bin/'

    # missing headers
    $(INSTALL) -m644 '$(1)/include/'thr_* '$(1)/include/'my_thr* '$(PREFIX)/$(TARGET)/include'

    # build test with mysql_config, disabled since it needs comp_sql from the scripts above
    # '$(TARGET)-g++' \
    #    -W -Wall -Werror -ansi -pedantic \
    #    '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
    #    `'$(PREFIX)/$(TARGET)/bin/mysql_config' --cflags --libs`
endef
