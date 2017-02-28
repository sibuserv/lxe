#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtsensors
    PKG_DEPS="qtbase"

    . "${PKG_DIR}/qtmodule.sh"
)

