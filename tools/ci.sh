#!/bin/sh

DEPLOY_TRG=${DEPLOY_TRG:-armv7-w64-mingw32}
if [ -d usr/$DEPLOY_TRG ]; then
  echo "Found target: $DEPLOY_TRG"
  DEPLOY_LST=`ls -t out/$DEPLOY_TRG/zip/latest/ | head -n 1 | cut -f 1 -d _`
  DEPLOY_PKG=${DEPLOY_PKG:-$DEPLOY_LST}
  DEPLOY_MKF=src/$DEPLOY_PKG.mk
  if [ -f $DEPLOY_MKF ]; then
    echo "Found package: $DEPLOY_PKG"
    DEPLOY_EXE=${DEPLOY_EXE:-test-$DEPLOY_PKG.exe}
    touch $DEPLOY_MKF
    if make $DEPLOY_PKG; then
      if [ -n $DEPLOY_NET ]; then
        DEPLOY_ZIP=${DEPLOY_PKG}_${DEPLOY_TRG}.zip
        echo; echo "Deploying $DEPLOY_ZIP to $DEPLOY_NET:"
        if scp out/${DEPLOY_TRG}/zip/latest/${DEPLOY_ZIP} $DEPLOY_NET:$DEPLOY_DIR
        then
          ssh $DEPLOY_NET -C "unzip -o $DEPLOY_ZIP"
          if [ -n $DEPLOY_EXE ]; then
            echo; echo "Running $DEPLOY_EXE on $DEPLOY_NET (assuming correct PATH):"
            ssh $DEPLOY_NET -C "$DEPLOY_EXE"
          fi
        fi
      fi
    fi
    else echo "No such package: $DEPLOY_PKG"
  fi
else echo "No such target: $DEPLOY_TRG"
fi
