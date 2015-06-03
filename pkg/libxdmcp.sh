#!/bin/sh

[ -z "${LIBXDMCP_VER}" ] && exit 1

(
    PKG=libxdmcp
    PKG_VERSION=${LIBXDMCP_VER}
    PKG_SUBDIR_ORIG=libXdmcp-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings makedepend x11proto-core"

    . "${PKG_DIR}/libxmodule.sh"
)

