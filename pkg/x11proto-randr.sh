#!/bin/sh

[ -z "${X11PROTO_RANDR_VER}" ] && exit 1

(
    PKG=x11proto-randr
    PKG_VERSION=${X11PROTO_RANDR_VER}
    PKG_SUBDIR_ORIG=randrproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

