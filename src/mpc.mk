# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mpc
$(PKG)_WEBSITE  := http://www.multiprecision.org/
$(PKG)_DESCR    := GNU MPC
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459
$(PKG)_SUBDIR   := mpc-$($(PKG)_VERSION)
$(PKG)_FILE     := mpc-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/mpc/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc gmp mpfr

$(PKG)_DEPS_$(BUILD) := gmp mpfr

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://ftp.gnu.org/gnu/mpc/)
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp='$(PREFIX)/$(TARGET)/' \
        --with-mpfr='$(PREFIX)/$(TARGET)/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_$(BUILD))
    # build runtime tests to verify toolchain components
    -$(MAKE) -C '$(1)' -j '$(JOBS)' check -k TESTS=
    rm -rf '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    cp -R '$(1)/tests' '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests'
    (printf 'date /t >  all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'time /t >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n'; \
     printf 'set PATH=..\\;%%PATH%%\r\n'; \
     printf 'for /R %%%%f in (*.exe) do %%%%f || echo %%%%f fail >> all-tests-$(PKG)-$($(PKG)_VERSION).txt\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/$(PKG)-tests/all-tests-$(PKG)-$($(PKG)_VERSION).bat'
endef
