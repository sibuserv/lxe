#!/bin/sh

[ -z "${LIBICE_VER}" ] && exit 1

(
    PKG=libice
    PKG_VERSION=${LIBICE_VER}
    PKG_SUBDIR_ORIG=libICE-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core xtrans"

    . "${PKG_DIR}/libxmodule.sh"

    if [ "${DEFAULT_LIB_TYPE}" = "static" ]
    then
        rm -f "${SYSROOT}/usr/lib/libICE.so"
    fi
)

