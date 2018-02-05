#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${GCC_VER}" ] && exit 1

(
    PKG=gcc
    PKG_VERSION=${GCC_VER}
    PKG_DEPS="glibc pthreads"

    . "${PKG_DIR}/gcc-common.sh"
)

