#!/bin/sh

[ -z "${X11PROTO_RENDER_VER}" ] && exit 1

(
    PKG=x11proto-render
    PKG_VERSION=${X11PROTO_RENDER_VER}
    PKG_SUBDIR_ORIG=renderproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

