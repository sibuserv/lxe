#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=exiv2
    PKG_VERSION=${EXIV2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://github.com/Exiv2/exiv2/archive/v${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib expat"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)
