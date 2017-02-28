#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtgraphicaleffects
    PKG_DEPS="qtbase qtdeclarative"

    . "${PKG_DIR}/qtmodule.sh"
)

