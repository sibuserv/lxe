#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libxfixes
    PKG_VERSION=${LIBXFIXES_VER}
    PKG_SUBDIR_ORIG=libXfixes-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-fixes libx11 libxext"

    . "${PKG_DIR}/libxmodule.sh"
)

