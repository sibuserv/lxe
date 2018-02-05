#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtlocation
    PKG_DEPS="qtbase qtdeclarative qtmultimedia"

    . "${PKG_DIR}/qtmodule.sh"
)

