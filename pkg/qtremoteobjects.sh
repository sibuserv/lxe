#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qtremoteobjects
    PKG_DEPS="qtbase qtdeclarative"

    if IsVer1GreaterOrEqualToVer2 "${QT5_VER}" "5.11.0"
    then
        . "${PKG_DIR}/qtmodule.sh"
    else
        . "${PKG_DIR}/qtmodule-nonexistent.sh"
    fi
)

