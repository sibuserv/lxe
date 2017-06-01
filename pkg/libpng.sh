#!/bin/sh

[ -z "${LIBPNG_VER}" ] && exit 1

(
    PKG=libpng
    PKG_VERSION=${LIBPNG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz
    IsPkgVersionGreaterOrEqualTo "1.2.56" && \
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/libpng12/${PKG_VERSION}/${PKG_FILE}" || \
        PKG_URL="https://sourceforge.net/projects/${PKG}/files/libpng12/older-releases/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProject

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

