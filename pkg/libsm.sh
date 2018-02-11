#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBSM_VER}" ] && exit 1

(
    PKG=libsm
    PKG_VERSION=${LIBSM_VER}
    PKG_SUBDIR_ORIG=libSM-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core xtrans libice"

    . "${PKG_DIR}/libxmodule.sh"

    if IsStaticPackage
    then
        rm -f "${SYSROOT}/usr/lib/libSM.so"
    fi
)

