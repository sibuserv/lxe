#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtquickcontrols
    PKG_DEPS="qtbase qtdeclarative"

    . "${PKG_DIR}/qtmodule.sh"
)

