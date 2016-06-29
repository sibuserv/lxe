#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtsvg

    . "${PKG_DIR}/qtmodule.sh"
)

