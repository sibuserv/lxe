#!/bin/sh

[ -z "${X11PROTO_GL_VER}" ] && exit 1

(
    PKG=x11proto-gl
    PKG_VERSION=${X11PROTO_GL_VER}
    PKG_SUBDIR_ORIG=glproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

