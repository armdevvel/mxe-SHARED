# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ws2fwd
$(PKG)_DESCR    := POSIX/BSD forward headers to WinSock2
$(PKG)_IGNORE   :=
$(PKG)_SOURCE_DIR := $(PWD)/resources/nihil
$(PKG)_VERSION  := 0.0.0
$(PKG)_DEPS     := llvm-mingw

$(PKG)_INSTALL  := $(PREFIX)/$(TARGET)/include

define $(PKG)_BUILD
    # endian.h, nameser.h and netdb.h should be provided by libbsd
    # or a similar compatibility layer. the below headers, however,
    # are trivially implemented by WinSock2

    mkdir -p '$($(PKG)_INSTALL)/sys' && echo '#include <ws2tcpip.h>' \
        > '$($(PKG)_INSTALL)/sys/socket.h'

    mkdir -p '$($(PKG)_INSTALL)/arpa' && echo '#include <winsock2.h>' \
        > '$($(PKG)_INSTALL)/arpa/inet.h'

    mkdir -p '$($(PKG)_INSTALL)/netinet' && echo '#include <winsock2.h>' \
    | tee '$($(PKG)_INSTALL)/netinet/in_systm.h' \
    | tee '$($(PKG)_INSTALL)/netinet/in.h' \
        > '$($(PKG)_INSTALL)/netinet/ip.h'
endef