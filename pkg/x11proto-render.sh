#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=x11proto-render
    PKG_VERSION=${X11PROTO_RENDER_VER}
    PKG_SUBDIR_ORIG=renderproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

