#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${PROJ_VER}" ] && exit 1

(
    PKG=proj
    PKG_VERSION=${PROJ_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="http://download.osgeo.org/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProject \
            --with-mutex
    fi
)

