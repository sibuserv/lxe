#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libxml2
    PKG_VERSION=${LIBXML2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="ftp://xmlsoft.org/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject \
            --without-python \
            --without-debug \
            --without-threads

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/xml2-config" "${TARGET}-xml2-config"
        ln -sf "${TARGET}-xml2-config" "xml2-config" 
    fi
)

