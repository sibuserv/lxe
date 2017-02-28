#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtserialport
    PKG_DEPS="qtbase"

    . "${PKG_DIR}/qtmodule.sh"
)

