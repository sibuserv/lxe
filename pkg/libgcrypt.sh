#!/bin/sh

[ -z "${LIBGCRYPT_VER}" ] && exit 1

(
    PKG=libgcrypt
    PKG_VERSION=${LIBGCRYPT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.gnupg.org/gcrypt/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc libgpg-error"

    if ! IsPkgInstalled
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

