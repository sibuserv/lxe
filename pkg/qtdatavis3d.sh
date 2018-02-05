#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtdatavis3d
    PKG_DEPS="qtbase qtdeclarative qtmultimedia"

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

