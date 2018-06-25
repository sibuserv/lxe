#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libxss
    PKG_VERSION=${LIBXSS_VER}
    PKG_SUBDIR_ORIG=libXScrnSaver-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-scrnsaver libx11 libxext"

    . "${PKG_DIR}/libxmodule.sh"
)

