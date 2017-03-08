#!/bin/sh

[ -z "${LIBXSS_VER}" ] && exit 1

(
    PKG=libxss
    PKG_VERSION=${LIBXSS_VER}
    PKG_SUBDIR_ORIG=libXScrnSaver-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-scrnsaver libx11 libxext"

    . "${PKG_DIR}/libxmodule.sh"
)

