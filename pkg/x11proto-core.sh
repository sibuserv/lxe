#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=x11proto-core
    PKG_VERSION=${X11PROTO_CORE_VER}
    PKG_SUBDIR_ORIG=xproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

