#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXEXT_VER}" ] && exit 1

(
    PKG=libxext
    PKG_VERSION=${LIBXEXT_VER}
    PKG_SUBDIR_ORIG=libXext-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core x11proto-kb x11proto-xext libx11"

    . "${PKG_DIR}/libxmodule.sh"
)

