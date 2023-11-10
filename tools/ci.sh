#!/bin/sh

TOUCH=touch

while :; do
  case "$1" in
    -h) cat << 'EOHELP'

    tools/ci.sh is a simple script for package build/test automation.

    Parameters are accepted in the form of environment variables:

    DEPLOY_TRG  target architecture     (default: 'armv7-w64-mingw32')
    DEPLOY_PKG  package to test         (default: last built)
    DEPLOY_NET  [user@]host to scp to   (no default)
    DEPLOY_DIR  installation directory, e.g. emulated sysroot (no default)
    DEPLOY_EXE  test case command line  (default: 'test-<DEPLOY_PKG>.exe')
    DEPLOY_DBG  instrumentation program (no default)

    You may want to set DEPLOY_NET and DEPLOY_DIR in your '.bashrc' file.

    The following command line switches are accepted:
      -h    display this help page and exit
      -k    do not force rebuild
      -c    use `catchsegv` as DEPLOY_DBG (assuming DrMingw is installed)

    Prerequisites:
      (1) sshd (package 'openssh-portable') must be running on the target;
      (2) unzip must be installed on the target and present in the $PATH.

EOHELP
      exit 0
      ;;
    -k) TOUCH=true
      ;;
    -c) DEPLOY_DBG="catchsegv"
      ;;
    *) break
  esac

  shift
done

DEPLOY_TRG="${DEPLOY_TRG:-armv7-w64-mingw32}"

if [ -d usr/$DEPLOY_TRG ]; then
  echo "Found target: $DEPLOY_TRG"
  DEPLOY_LST=`ls -t out/$DEPLOY_TRG/zip/latest/ | head -n 1 | cut -f 1 -d _`
  DEPLOY_PKG="${DEPLOY_PKG:-$DEPLOY_LST}"
  DEPLOY_MKF="src/$DEPLOY_PKG.mk"
  if [ -f "$DEPLOY_MKF" ]; then
    echo "Found package: $DEPLOY_PKG"
    DEPLOY_EXE=${DEPLOY_EXE:-test-$DEPLOY_PKG.exe}
    if [ -n "$DEPLOY_DBG" ]; then
      echo "Run test with: ${DEPLOY_DBG}"
      DEPLOY_EXE="${DEPLOY_DBG} ${DEPLOY_EXE}"
    fi
    if [ 'true' = "$TOUCH" ] && grep -H -v '^#' "$DEPLOY_MKF" | grep _SOURCE_TREE; then
      echo "Note: make can't detect changes in local sources. Consider running w/o -k."
      echo
    fi
    $TOUCH "$DEPLOY_MKF"
    if make "$DEPLOY_PKG"; then
      if [ -n "$DEPLOY_NET" ]; then
        DEPLOY_ZIP="${DEPLOY_PKG}_${DEPLOY_TRG}.zip"
        echo; echo "Deploying $DEPLOY_ZIP to $DEPLOY_NET:$DEPLOY_DIR"
        if scp "out/${DEPLOY_TRG}/zip/latest/${DEPLOY_ZIP}" "$DEPLOY_NET:$DEPLOY_DIR"
        then
          echo "Unpacking: cd $DEPLOY_DIR && unzip -o $DEPLOY_ZIP"
          ssh "$DEPLOY_NET" -C "cd $DEPLOY_DIR && unzip -o $DEPLOY_ZIP"
          if [ -n "$DEPLOY_EXE" ]; then
            echo; echo "Running $DEPLOY_EXE on $DEPLOY_NET (assuming correct PATH):"
            ssh "$DEPLOY_NET" -C "$DEPLOY_EXE"
          fi
        fi
      fi
    fi
    else echo "No such package: $DEPLOY_PKG"
  fi
else echo "No such target: $DEPLOY_TRG"
fi
