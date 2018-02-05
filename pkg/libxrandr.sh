#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXRANDR_VER}" ] && exit 1

(
    PKG=libxrandr
    PKG_VERSION=${LIBXRANDR_VER}
    PKG_SUBDIR_ORIG=libXrandr-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-randr libx11 libxext libxrender"

    . "${PKG_DIR}/libxmodule.sh"
)

