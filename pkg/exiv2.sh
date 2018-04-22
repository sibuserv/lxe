#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${EXIV2_VER}" ] && exit 1

(
    PKG=exiv2
    PKG_VERSION=${EXIV2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="http://www.exiv2.org/${PKG_FILE}"
    PKG_DEPS="gcc zlib expat"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

