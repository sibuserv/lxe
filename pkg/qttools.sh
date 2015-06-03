#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qttools

    . "${PKG_DIR}/qtmodule.sh"
)

