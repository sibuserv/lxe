#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libgpg-error
    PKG_VERSION=${LIBGPG_ERROR_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.gnupg.org/gcrypt/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject \
            --disable-nls \
            --disable-languages

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/gpg-error-config" "${TARGET}-gpg-error-config"
        ln -sf "${TARGET}-gpg-error-config" "gpg-error-config" 
    fi
)

