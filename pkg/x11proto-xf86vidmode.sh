#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=x11proto-xf86vidmode
    PKG_VERSION=${X11PROTO_XF86VIDMODE_VER}
    PKG_SUBDIR_ORIG=xf86vidmodeproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

