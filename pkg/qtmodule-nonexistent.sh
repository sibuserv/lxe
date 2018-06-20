#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${PKG}" ] && exit 1

(
    if IsBuildRequired
    then
        CheckDependencies

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

