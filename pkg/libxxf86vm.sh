#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libxxf86vm
    PKG_VERSION=${LIBXXF86VM_VER}
    PKG_SUBDIR_ORIG=libXxf86vm-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-xf86vidmode libx11 libxext"

    . "${PKG_DIR}/libxmodule.sh"
)

