#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qtquickcontrols2
    PKG_DEPS="qtbase qtdeclarative qtmultimedia"

    if IsVer1GreaterOrEqualToVer2 "${QT5_VER}" "5.6.0"
    then
        . "${PKG_DIR}/qtmodule.sh"
    else
        . "${PKG_DIR}/qtmodule-nonexistent.sh"
    fi
)

