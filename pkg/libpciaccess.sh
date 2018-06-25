#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libpciaccess
    PKG_VERSION=${LIBPCIACCESS_VER}
    PKG_DEPS="gcc pkg-config-settings zlib"

    . "${PKG_DIR}/libxmodule.sh"
)

