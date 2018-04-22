#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBPNG_VER}" ] && exit 1

(
    PKG=libpng
    PKG_VERSION=${LIBPNG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz
    PKG_URL="https://sourceforge.net/projects/${PKG}/files/libpng${LIBPNG_SUBVER}/${PKG_VERSION}/${PKG_FILE}"
    PKG_URL_2="https://sourceforge.net/projects/${PKG}/files/libpng${LIBPNG_SUBVER}/older-releases/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

