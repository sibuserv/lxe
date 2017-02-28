#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtmultimedia

    . "${PKG_DIR}/qtmodule.sh"
)

