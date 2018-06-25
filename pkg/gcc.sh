#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=gcc
    PKG_VERSION=${GCC_VER}
    PKG_DEPS="glibc pthreads"

    . "${PKG_DIR}/gcc-common.sh"
)

