#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

if [ "${USE_JPEG_TURBO}" != "true" ]
then
    echo "[config]   ${CONFIG}"
    echo "[build]    libjpeg-turbo"
    echo "Error! You cannot build package \"libjpeg-turbo\" because"
    echo "USE_JPEG_TURBO variable is not set to \"true\"."
    exit 1
fi

(
    PKG=libjpeg-turbo
    PKG_VERSION=${JPEG_TURBO_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://downloads.sourceforge.net/project/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc yasm"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject
    fi
)

