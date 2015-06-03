#!/bin/sh

[ -z "${LIBX11_VER}" ] && exit 1

(
    PKG=libx11
    PKG_VERSION=${LIBX11_VER}
    PKG_SUBDIR_ORIG=libX11-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-xext x11proto-kb x11proto-input x11proto-xf86bigfont xtrans libxcb"

    . "${PKG_DIR}/libxmodule.sh"
)

