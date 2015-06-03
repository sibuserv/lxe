#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qt5
    PKG_DEPS="qtbase qttools qtserialport qtscript qtwebsockets"

    if ! IsPkgInstalled
    then
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[no-build] ${PKG}"
    fi
)

