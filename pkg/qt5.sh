#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qt5
    PKG_DEPS="qtbase
              qtactiveqt
              qtcanvas3d
              qtcharts
              qtconnectivity
              qtdatavis3d
              qtdeclarative
              qtgamepad
              qtgraphicaleffects
              qtlocation
              qtmultimedia
              qtquickcontrols2
              qtquickcontrols
              qtscript
              qtsensors
              qtserialport
              qtsvg
              qttools
              qttranslations
              qtvirtualkeyboard
              qtwebchannel
              qtwebsockets
              qtx11extras
              qtxmlpatterns"

    if ! IsPkgInstalled
    then
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

