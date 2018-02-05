#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXRENDER_VER}" ] && exit 1

(
    PKG=libxrender
    PKG_VERSION=${LIBXRENDER_VER}
    PKG_SUBDIR_ORIG=libXrender-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-render libx11"

    . "${PKG_DIR}/libxmodule.sh"
)

