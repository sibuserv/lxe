#!/bin/sh

[ -z "${LIBXAU_VER}" ] && exit 1

(
    PKG=libxau
    PKG_VERSION=${LIBXAU_VER}
    PKG_SUBDIR_ORIG=libXau-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core"

    . "${PKG_DIR}/libxmodule.sh"
)

