#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtvirtualkeyboard
    PKG_DEPS="qtbase qtdeclarative qtmultimedia qtquickcontrols qtsvg"

    if ! IsPkgInstalled
    then
        if IsVer1GreaterOrEqualToVer2 "${QT5_VER}" "5.7.0"
        then
            . "${PKG_DIR}/qtmodule.sh"
        else
            CheckDependencies

            date -R > "${INST_DIR}/${PKG}"
            echo "[config]   ${CONFIG}"
            echo "[no-build] ${PKG}"
        fi
    fi
)

