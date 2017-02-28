#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtdeclarative
    PKG_DEPS="qtbase qtsvg qtxmlpatterns"

    . "${PKG_DIR}/qtmodule.sh"
)

