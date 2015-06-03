#!/bin/sh

[ -z "${XTRANS_VER}" ] && exit 1

(
    PKG=xtrans
    PKG_VERSION=${XTRANS_VER}
    PKG_DEPS="gcc pkg-config-settings makedepend"

    . "${PKG_DIR}/libxmodule.sh"
)

