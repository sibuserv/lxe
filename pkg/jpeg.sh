#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${JPEG_VER}" ] && exit 1

(
    PKG=jpeg
    PKG_VERSION=${JPEG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=jpegsrc.v${PKG_VERSION}.tar.gz
    PKG_URL="http://www.ijg.org/files/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

