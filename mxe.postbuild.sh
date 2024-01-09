#!/bin/bash

set -e

# avoid specific action names like "archive" or "codesign"
# -- all package grooming for deployment will happen here
TARGET="${2}"
TMPDIR="tmp-${1}_${2}-postbuild"
mkdir -p "$TMPDIR"

# The Debian convention is "Foo_ver[-rev]_arch"
FOONAME=`echo ${1} | tr '[:upper:] _' '[:lower:]-'`
FOO_VER=`echo $VERSION | tr '[:upper:] _' '[:lower:]-'`

OUTDIR="./out/${2}"
TGZDIR="$OUTDIR/tgz"
ZIPDIR="$OUTDIR/zip"
DEBDIR="$OUTDIR/deb"

mkdir -p "$TGZDIR/latest"
mkdir -p "$ZIPDIR/latest"
mkdir -p "$DEBDIR/latest"

# The target (Makefile's $(3) turned ${2})  won't be sanitized:
# 1. it's the last component anyway ("cut -d '_' 3-" will work),
# 2. packages for different targets are never deployed together;
# 3. unfortunately, x86_64 traditionally contains an underscore.
Q_NAME="${FOONAME}_${FOO_VER}_${2}" # =qualified (absolute) name
LATEST="latest/${FOONAME}_${2}" # =symbolic link to latest-built

OUTTGZ="$TGZDIR/$Q_NAME.tar.gz"
OUTZIP="$ZIPDIR/$Q_NAME.zip"
OUTDEB="$DEBDIR/$Q_NAME.deb"    # not built yet: needs dep/graph

# tape archives are compressed in streaming mode for efficiency
# (dictionary reuse). first we append into them, then compress.
TMPTAR="$TMPDIR/$VERSION.tar" # ($TARGET is already in $TMPDIR)
TMPZIP="$TMPDIR/$VERSION.lst" # proto-zip is simply a file list

# absolute paths for access inside pushd-popd
ABSTAR=`realpath "$TMPTAR"`
ABSZIP=`realpath "$OUTZIP"`
ABSLST=`realpath "$TMPZIP"`

# TODO inject dependencies (with their own versions)
# ROADMAP fix non-comparable versions (e.g. commit hashes)

# Now: we are only interested in files in $PREFIX/$TARGET,
# and only if $TARGET != $BUILD:
if [ "x$TARGET" != "x$BUILD" ]; then
    echo Locating tar:
    which tar
    echo Locating zip:
    which zip
    echo Locating gzip:
    which gzip

    rm -f "$TMPTAR"; touch "$TMPTAR"
    rm -f "$TMPZIP"; touch "$TMPZIP"
fi

find "$PREFIX" -newer "$CUTOFF" | while read installable
do
    # (We still sign PE32 binaries everywhere we find them.)
    ext="${installable##*.}"
    case "$ext" in
    "exe" | "dll")
        # FIXME errors are not propagated up from osslsigncode -- troubleshoot!
        APPHDR="${1}" TMPDIR="$TMPDIR" "$PREFIX/bin/selfsign.sh" "$installable"
        ;;
    esac

    if [ "x$TARGET" != "x$BUILD" ]; then
        innerpath=`realpath "$installable" "--relative-to=$PREFIX/$TARGET"`
        if [ 'x..' != "x`echo $innerpath | cut -d '/' -f 1`" ]; then
            pushd "$PREFIX/$TARGET"
                tar --dereference --no-recursion --append -f "$ABSTAR" "$innerpath"
            popd
            echo "$innerpath" | tee >> "$TMPZIP"
        fi
    fi

    # TODO add to <pkg>.tar.gz
    # TODO add to <pkg>.deb
done

if [ -e "$TMPTAR" ]; then
    gzip "$TMPTAR" -c > "$OUTTGZ"
    echo ln -sf `realpath "$OUTTGZ" "--relative-to=$TGZDIR/latest"` "$TGZDIR/$LATEST.tar.gz"
    ln -sf `realpath "$OUTTGZ" "--relative-to=$TGZDIR/latest"` "$TGZDIR/$LATEST.tar.gz"
fi

if [ -e "$TMPZIP" ]; then
    pushd "$PREFIX/$TARGET"
        # pack a list of files
        zip "$ABSZIP" -@ < "$ABSLST"
    popd
    ln -sf `realpath "$OUTZIP" "--relative-to=$ZIPDIR/latest"` "$ZIPDIR/$LATEST.zip"
fi

# be conservative -- only remove (potentially) expected files here
rm -f "$TMPDIR"/signed* "$TMPTAR" "$TMPZIP"
rmdir "$TMPDIR"
