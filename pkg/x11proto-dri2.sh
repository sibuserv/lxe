#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=x11proto-dri2
    PKG_VERSION=${X11PROTO_DRI2_VER}
    PKG_SUBDIR_ORIG=dri2proto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

