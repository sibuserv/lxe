#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${YASM_VER}" ] && exit 1

(
    PKG=yasm
    PKG_VERSION=${YASM_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="http://www.tortall.net/projects/${PKG}/releases/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject \
            --bindir="${PREFIX}/bin" \
            --disable-nls
    fi
)

