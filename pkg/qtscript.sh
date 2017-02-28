#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtscript
    PKG_DEPS="qtbase"

    . "${PKG_DIR}/qtmodule.sh"
)

