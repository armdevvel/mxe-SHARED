PKG             := snakeoil
$(PKG)_WEBSITE  := https://github.com/armdevvel/mxe-SHARED/wiki/Code-signing-for-Windows-RT-with-open-source-tools
$(PKG)_DESCR    := OpenSSH configuration for self-signing PE binaries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.1
$(PKG)_CHECKSUM := eb2f8d74876bbcd9ac6feaa2e029701d7b909f2897a5b35f32511743f4c377ee
$(PKG)_SUBDIR   := snakeoil-$($(PKG)_VERSION)
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/treeswift/$(PKG)/archive/refs/tags/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS_$(BUILD) := osslsigncode openssl
$(PKG)_TARGETS  := $(BUILD)

$(PKG)_INSTALL := $(PREFIX)/local/ssl
$(PKG)_PRIVATE := $($(PKG)_INSTALL)/private
$(PKG)_SSLCONF := $($(PKG)_INSTALL)/snakeoil.cnf
$(PKG)_OPENSSL := $(PREFIX)/$(BUILD)/bin/openssl
$(PKG)_CODESIG := $(PREFIX)/$(BUILD)/bin/osslsigncode

# the default binary name is its file name without extension, default URL is this $(PKG)_WEBSITE
# osslsigncode's "-time 978307200" is Unix epoch of 20010101000000Z (seconds since Jan 1, 1970)
$(PKG)_MILLENNIUM = 978307200

define $(PKG)_GENBASH
#!/bin/bash\n\
\n\
if [ $$# -eq 0 ]; then echo "Usage: [ TMPDIR=./tmpdir ] selfsign.sh {program.exe|library.dll}"; exit 1; fi\n\
( file "$$1" | grep "PE32 executable" ) || exit 0\n\
\n\
SIGBIN="$($(PKG)_CODESIG)"\n\
SSLBIN="$($(PKG)_OPENSSL)"\n\
SSLDIR="$($(PKG)_INSTALL)"\n\
SSLCNF="$($(PKG)_SSLCONF)"\n\
\n\
BINARY=`realpath "$$1"`\n\
BASENM="$${BINARY##*/}"\n\
BINDIR=`dirname "$$BINARY"`\n\
SIGDIR="$${TMPDIR:-$$BINDIR}"\n\
SIGNED="$$SIGDIR/s1gned~$$BASENM"\n\
\n\
FILENM="$${BASENM%%.*}"\n\
APPHDR="$${APPHDR:-$$FILENM}"\n\
URLHDR="$${URLHDR:-$($(PKG)_WEBSITE)}"\n\
DATETM="$($(PKG)_MILLENNIUM)"\n\
\n\
"$$SIGBIN" sign -certs "$$SSLDIR/mxe.crt" -key "$$SSLDIR/private/mxe.key" \\\n\
-n "$$BASENM" -i "$$URLHDR" -in "$$BINARY" -out "$$SIGNED" -time "$$DATETM" \\\n\
-cmd "$$SSLBIN ts -reply -config $$SSLCNF -queryfile /dev/stdin -out -"  \\\n\
&& mv "$$SIGNED" "$$BINARY"
endef

define $(PKG)_BUILD_$(BUILD)
	'$(INSTALL)' -d '$(PREFIX)/local'
	'$(INSTALL)' -d '$($(PKG)_INSTALL)'
	'$(INSTALL)' -d '$($(PKG)_INSTALL)/private'

	$(SED) 's!$$ENV::OSSLDIR!$($(PKG)_INSTALL)!' '$(SOURCE_DIR)/snakeoil.cnf' \
		> '$($(PKG)_SSLCONF)'
	echo 01 > '$($(PKG)_INSTALL)/serial'
	echo -n > '$($(PKG)_INSTALL)/signlog.txt'
	
	# generate key
	'$($(PKG)_OPENSSL)' genrsa -out '$($(PKG)_PRIVATE)/mxe.key'

	# generate certificate signing request
	'$($(PKG)_OPENSSL)' req -config '$($(PKG)_SSLCONF)' \
	 	-new -key '$($(PKG)_PRIVATE)/mxe.key' -out '$(BUILD_DIR)/mxe.csr' \
		-subj '/name=Self-signed/commonName=Arbitrary self-signed code/'

	# approve CSR and generate code-signing certificate
	'$($(PKG)_OPENSSL)' ca -config '$($(PKG)_SSLCONF)' \
   		-keyfile '$($(PKG)_PRIVATE)/mxe.key' -in '$(BUILD_DIR)/mxe.csr' \
	 	-selfsign -batch -startdate 20010101000000Z -days 365000 \
		-out '$($(PKG)_INSTALL)/mxe.crt'

	# approve same CSR and generate timestamping certificate
	'$($(PKG)_OPENSSL)' ca -config '$($(PKG)_SSLCONF)' \
   		-keyfile '$($(PKG)_PRIVATE)/mxe.key' -in '$(BUILD_DIR)/mxe.csr' \
		-selfsign -batch -startdate 20010101000000Z -days 365000 \
		-out '$($(PKG)_INSTALL)/tsa.crt' -extensions tsa_cert

	/bin/echo -e '$($(PKG)_GENBASH)' | sed 's!^ !!' > '$(BUILD_DIR)/selfsign.sh' \
		&& $(INSTALL) -m 755 '$(BUILD_DIR)/selfsign.sh' '$(PREFIX)/bin/selfsign.sh'
endef
