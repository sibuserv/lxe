#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qt5
    PKG_VERSION=${QT5_VER}
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

    CheckPkgVersion

    if IsBuildRequired
    then
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

