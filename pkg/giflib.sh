#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${GIFLIB_VER}" ] && exit 1

(
    PKG=giflib
    PKG_VERSION=${GIFLIB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    if IsPkgVersionGreaterOrEqualTo "5.0.6"
    then
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/${PKG_FILE}"
    elif IsPkgVersionGreaterOrEqualTo "5.0.0"
    then
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/giflib-5.x/${PKG_FILE}"
    elif IsPkgVersionGreaterOrEqualTo "4.2.0"
    then
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/giflib-4.x/${PKG_FILE}"
    else
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/giflib-4.x/${PKG_SUBDIR}/${PKG_FILE}"
    fi
    PKG_DEPS="gcc zlib jpeg"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

