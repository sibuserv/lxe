#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=gcc-extra
    PKG_VERSION=${GCC_EXTRA_VER}
    PKG_SUBDIR_ORIG=gcc-${PKG_VERSION}
    PKG_DEPS="gcc"

    . "${PKG_DIR}/gcc-common.sh"
)

