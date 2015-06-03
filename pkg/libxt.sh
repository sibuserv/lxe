#!/bin/sh

[ -z "${LIBXT_VER}" ] && exit 1

(
    PKG=libxt
    PKG_VERSION=${LIBXT_VER}
    PKG_SUBDIR_ORIG=libXt-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend libx11 libsm libice"

    . "${PKG_DIR}/libxmodule.sh"
)

