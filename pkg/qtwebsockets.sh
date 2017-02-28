#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtwebsockets
    PKG_DEPS="qtbase"

    . "${PKG_DIR}/qtmodule.sh"
)

