#!/bin/sh

[ -z "${X11PROTO_SCRNSAVER_VER}" ] && exit 1

(
    PKG=x11proto-scrnsaver
    PKG_VERSION=${X11PROTO_SCRNSAVER_VER}
    PKG_SUBDIR_ORIG=scrnsaverproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

