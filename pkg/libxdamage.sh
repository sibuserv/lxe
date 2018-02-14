#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXDAMAGE_VER}" ] && exit 1

(
    PKG=libxdamage
    PKG_VERSION=${LIBXDAMAGE_VER}
    PKG_SUBDIR_ORIG=libXdamage-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-kb x11proto-damage libx11 libxext libxfixes"

    . "${PKG_DIR}/libxmodule.sh"
)

