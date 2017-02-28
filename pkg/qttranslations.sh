#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qttranslations
    PKG_DEPS="qtbase qttools"

    . "${PKG_DIR}/qtmodule.sh"
)

