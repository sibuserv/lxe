#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${X11PROTO_DAMAGE_VER}" ] && exit 1

(
    PKG=x11proto-damage
    PKG_VERSION=${X11PROTO_DAMAGE_VER}
    PKG_SUBDIR_ORIG=damageproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

