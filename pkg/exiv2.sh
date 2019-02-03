#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=exiv2
    PKG_VERSION=${EXIV2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="http://www.exiv2.org/releases/${PKG_FILE}"
    PKG_DEPS="gcc zlib expat"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

