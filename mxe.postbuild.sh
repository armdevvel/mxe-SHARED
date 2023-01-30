#!/bin/bash

# avoid specific action names like "archive" or "codesign"
# -- all package grooming for deployment will happen here
TMPDIR="tmp-${1}_${2}-postbuild"
mkdir -p "$TMPDIR"

# TODO inject VERSION and dependencies (with own versions)
# ROADMAP fix non-comparable versions (e.g. commit hashes)

find "$PREFIX" -newer "$CUTOFF" | while read installable
do
    ext="${installable##*.}"
    case "$ext" in
    "exe" | "dll")
        # FIXME errors are not propagated up from osslsigncode -- troubleshoot!
        APPHDR="${1}" TMPDIR="$TMPDIR" "$PREFIX/bin/selfsign.sh" "$installable"
        ;;
    esac

    # TODO add to <pkg>.tar.gz
    # TODO add to <pkg>.deb
done

# be conservative -- only remove (potentially) expected files here
rm "$TMPDIR"/signed*
rmdir "$TMPDIR"
