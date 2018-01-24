#!/bin/sh

[ -z "${CURL_VER}" ] && exit 1

(
    PKG=curl
    PKG_VERSION=${CURL_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://curl.haxx.se/download/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProject \
            --without-gnutls \
            --without-ssl \
            --without-libidn2 \
            --without-libssh2 \
            --enable-sspi \
            --enable-ipv6

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config"
    fi
)

