# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := perl
$(PKG)_WEBSITE  := https://www.perl.org
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.36.0
$(PKG)_CHECKSUM := e26085af8ac396f62add8a533c3a0ea8c8497d836f0689347ac5abd7b7a4e00a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://www.cpan.org/src/5.0/$($(PKG)_FILE)
$(PKG)_DEPS     := cc pthreads perl-cross libwusers

$(PKG)_TARGET_EXTRAS = win32.c win32thread.c win32sck.c fcrypt.c
$(PKG)_VERSED_FOLDER = perl5/$($(PKG)_VERSION)
$(PKG)_PUBLIC_HEADER = 

define $(PKG)_BUILD
    # hacky, but, OTOH, avoiding wildcards
    cp -r --no-preserve=all '$(SOURCE_DIR)' '$(BUILD_DIR)'
    $(call PREPARE_PKG_SOURCE,perl-cross,'$(SOURCE_DIR)')
    cd '$(SOURCE_DIR)' && mv '$(perl-cross_SUBDIR)' '$(perl_SUBDIR)' && cp -r '$(perl_SUBDIR)' '$(BUILD_DIR)/'
    
    $(foreach script, \
            cflags makedepend makedepend_file Makefile Makefile.config \
            metaconfig myconfig runtests Policy_sh pod/Makefile config_h \
        , chmod 0755 '$(BUILD_DIR)/$(perl_SUBDIR)/$(script).SH'; )

    $(foreach winsrc,$($(PKG)_TARGET_EXTRAS), \
        ln -s '$(BUILD_DIR)/$(perl_SUBDIR)/win32/$(winsrc)' '$(BUILD_DIR)/$(perl_SUBDIR)/'; )

    # prior to manual setup, ccflags was:
    # ccflags='--sysroot=$(PREFIX)/$(TARGET) -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64'
    
    # some of the flags are well-intended but only effective in ./Configure rather than
    # the (perl-cross originating) ./configure -- kept as hints for any further porters

    # patch sets in `perl` and `perl-cross` are related and should be applied together!

    cd '$(BUILD_DIR)/$(perl_SUBDIR)' && X=.exe $(SHELL) ./configure \
        '--prefix=$(PREFIX)/$(TARGET)' \
        '--sysroot=$(PREFIX)/$(TARGET)' \
        '--build=$(BUILD)' \
        '--target=$(TARGET)' \
        '--with-cc=$(TARGET)-gcc' \
        '--use-threads' \
        '--hints=mswin32' '-Dosname=MSWin32' \
        '-Duseshrplib' '-Ddlext=.dll' '-Dexe_ext=.exe' '-Dallstatic=0' '-Dlibperl=perl.dll' \
        '-Dshrpldflags=-Wl,--out-implib=$(BUILD_DIR)/$(perl_SUBDIR)/libperl.a' \
        '-Dlinklibperl=-L$(BUILD_DIR)/$(perl_SUBDIR) -lperl' \
        '-Dusemultiplicity=define' \
        '-Dcharsize=1' '-Dshortsize=2' '-Dintsize=4' '-Dlongsize=4' \
        '-Ddoublesize=8' '-Dlongdblsize=12' '-Dlonglongsize=8' \
        '-Dptrsize=4' '-Dsizesize=4' '-Dfpossize=8' '-Dlseeksize=8' \
        '-Dtimesize=64' '-Duvsize=4' '-Divsize=4' '-Dnvsize=8' \
        '-Dd_nanosleep=undef' '-Duseithreads=undef' \
        '-Ddirentrytype=struct direct' \
        '-Ddrand01=Perl_drand48()' \
        '-Dccflags=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -D__MINGW32__ -DPERLDLL \
            -DPERL_USE_SAFE_PUTENV \
            -isystem $(BUILD_DIR)/$(perl_SUBDIR)/win32 \
            -isystem $(BUILD_DIR)/$(perl_SUBDIR)/win32/include \
            -isystem $(PREFIX)/$(TARGET)/include \
            --sysroot=$(PREFIX)/$(TARGET)' \
        '-Dccdlflags=-Wl,--export-all-symbols' \
        '-Dldflags=-L$(PREFIX)/$(TARGET)/lib -lcomctl32 -lgdi32 -ladvapi32 \
            -luser32 -lwinspool -lshell32 -lole32 -loleaut32 \
            -lnetapi32 -luuid -lws2_32 -lmpr -lwinmm -lversion'

    $(MAKE) -C '$(BUILD_DIR)/$(perl_SUBDIR)' -j '$(JOBS)' \
            PATCHED_PERL_DIR='$(BUILD_DIR)/$(perl_SUBDIR)'
    
    # passing absolute paths to install targets leads to barbaric locations -- such
    # as "usr/armv7-w64-mingw32/home/dev/Code/mxe-shared/usr/armv7-w64-mingw32/lib"
    # therefore make install is commented out and replaced with explicit $(INSTALL)
    # (future generations MAY want to fix it):
    # $(MAKE) -C '$(BUILD_DIR)/$(perl_SUBDIR)' DESTDIR='$(PREFIX)/$(TARGET)' \
    #         X=.exe installbin=/bin install

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/$($(PKG)_VERSED_FOLDER)'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/$($(PKG)_VERSED_FOLDER)'

    cd '$(BUILD_DIR)/$(perl_SUBDIR)/lib' && \
        ( \
            find -name '*.pl'; \
            find -name '*.pm'; \
            find -name '*.ld'; \
            find -name '*.txt' \
            find -name '*.yml' \
            find -name '*.dd'; \
            echo ExtUtils/MANIFEST.SKIP; \
            echo ExtUtils/typemap; \
            echo ExtUtils/xsubpp; \
            echo unicore/version; \
        ) | while read path; do \
        $(INSTALL) -m 644 -D "$$path" \
            "$(PREFIX)/$(TARGET)/bin/$($(PKG)_VERSED_FOLDER)/$$path"; \
    done

    $(INSTALL) -m 644 '$(BUILD_DIR)/$(perl_SUBDIR)/perl.exe' \
            '$(PREFIX)/$(TARGET)/bin/$($(PKG)_VERSED_FOLDER)'
    $(INSTALL) -m 644 '$(BUILD_DIR)/$(perl_SUBDIR)/perl.dll' \
            '$(PREFIX)/$(TARGET)/bin/$($(PKG)_VERSED_FOLDER)'
    $(INSTALL) -m 644 '$(BUILD_DIR)/$(perl_SUBDIR)/libperl.a' \
            '$(PREFIX)/$(TARGET)/lib/$($(PKG)_VERSED_FOLDER)'

    ln -sf '$($(PKG)_VERSED_FOLDER)/libperl.a' \
            '$(PREFIX)/$(TARGET)/lib'
    ln -sf '$($(PKG)_VERSED_FOLDER)/perl.dll' \
            '$(PREFIX)/$(TARGET)/bin'
    ln -sf '$($(PKG)_VERSED_FOLDER)/perl$($(PKG)_VERSION).exe' \
            '$(PREFIX)/$(TARGET)/bin/perl.exe'
    ln -sf '$($(PKG)_VERSED_FOLDER)/perl.exe' \
            '$(PREFIX)/$(TARGET)/bin'

    # the location is not exactly canonical, but likely functional (Perl files
    # aren't executable on Windows, therefore PATH won't be considered anyway)
    cd '$(BUILD_DIR)/$(perl_SUBDIR)/utils' \
        && $(INSTALL) -m 644 --target-directory '$(PREFIX)/$(TARGET)/bin/perl5/' \
            `ls | grep -v PL | grep -v Makefile`

    # ditto -- foreach(app|embedding a Perl interpreter) app.heads(up)
    $(INSTALL) -d \
            '$(PREFIX)/$(TARGET)/include/$($(PKG)_SUBDIR)/'
    ls '$(BUILD_DIR)/$(perl_SUBDIR)/*.h' | while read path; do \
        $(INSTALL) -m 644 "$$path" \
            '$(PREFIX)/$(TARGET)/include/$($(PKG)_SUBDIR)/'; \
    done
    ln -sf $($(PKG)_SUBDIR) \
        '$(PREFIX)/$(TARGET)/include/perl5'

    # unlikely, but certain scripts might request "site_perl"
    # even outside a CGI environment, so let's have it anyway
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/perl5/site_perl/$($(PKG)_VERSION)'
endef
