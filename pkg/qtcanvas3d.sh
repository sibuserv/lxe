#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtcanvas3d
    PKG_DEPS="qtbase qtdeclarative"

    if IsVer1GreaterOrEqualToVer2 "${QT5_VER}" "5.5.0"
    then
        . "${PKG_DIR}/qtmodule.sh"
    else
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

