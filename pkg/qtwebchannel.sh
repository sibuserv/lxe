#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtwebchannel
    PKG_DEPS="qtbase qtdeclarative qtwebsockets"

    . "${PKG_DIR}/qtmodule.sh"
)

