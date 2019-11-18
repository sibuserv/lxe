#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=gcc
    PKG_VERSION=${GCC_VER}
    PKG_DEPS="glibc pthreads"
    
    [ "${LXE_USE_CCACHE}" = "true" ] && PKG_DEPS="ccache ${PKG_DEPS}"

    . "${PKG_DIR}/gcc-common.sh"
)

