#!/bin/sh

[ -z "${GCC_EXTRA_VER}" ] && exit 1

(
    PKG=gcc-extra
    PKG_VERSION=${GCC_EXTRA_VER}
    PKG_SUBDIR_ORIG=gcc-${PKG_VERSION}
    PKG_DEPS="gcc"

    . "${PKG_DIR}/gcc-common.sh"
)

