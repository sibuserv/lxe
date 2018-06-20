#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBGCRYPT_VER}" ] && exit 1

(
    PKG=libgcrypt
    PKG_VERSION=${LIBGCRYPT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.gnupg.org/gcrypt/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc libgpg-error"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject \
            --with-gpg-error-prefix="${SYSROOT}/usr" \
            --disable-doc \
            --disable-asm \
            cross_compiling=yes

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

