#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${X11PROTO_KB_VER}" ] && exit 1

(
    PKG=x11proto-kb
    PKG_VERSION=${X11PROTO_KB_VER}
    PKG_SUBDIR_ORIG=kbproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

