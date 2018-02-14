#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXI_VER}" ] && exit 1

(
    PKG=libxi
    PKG_VERSION=${LIBXI_VER}
    PKG_SUBDIR_ORIG=libXi-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-xext x11proto-input libx11 libxext libxfixes"

    . "${PKG_DIR}/libxmodule.sh"
)

