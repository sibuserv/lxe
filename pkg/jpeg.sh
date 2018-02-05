#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

if [ "${USE_JPEG_TURBO}" = "true" ]
then
    echo "[build]    jpeg"
    echo "Error! You cannot build package \"jpeg\" because"
    echo "USE_JPEG_TURBO variable is set to \"true\"."
    exit 1
fi

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

