#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtserialport

    . "${PKG_DIR}/qtmodule.sh"
)

