#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qt5
    PKG_DEPS="qtbase qtconnectivity qtscript qtserialport qtsvg qttools qtwebsockets"

    if ! IsPkgInstalled
    then
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

