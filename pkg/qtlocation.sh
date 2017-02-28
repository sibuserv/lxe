#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtlocation
    PKG_DEPS="qtbase qtdeclarative qtmultimedia"

    . "${PKG_DIR}/qtmodule.sh"
)

