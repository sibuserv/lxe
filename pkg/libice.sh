#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libice
    PKG_VERSION=${LIBICE_VER}
    PKG_SUBDIR_ORIG=libICE-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core xtrans"

    . "${PKG_DIR}/libxmodule.sh"

    if IsStaticPackage
    then
        rm -f "${SYSROOT}/usr/lib/libICE.so"
    fi
)

