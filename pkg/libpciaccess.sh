#!/bin/sh

[ -z "${LIBPCIACCESS_VER}" ] && exit 1

(
    PKG=libpciaccess
    PKG_VERSION=${LIBPCIACCESS_VER}
    PKG_DEPS="gcc pkg-config-settings zlib"

    . "${PKG_DIR}/libxmodule.sh"
)

