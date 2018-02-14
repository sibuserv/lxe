#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtconnectivity
    PKG_DEPS="qtbase"

    . "${PKG_DIR}/qtmodule.sh"
)

