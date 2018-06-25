#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=tiff
    PKG_VERSION=${TIFF_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    IsPkgVersionGreaterOrEqualTo "4.0.4" && \
        PKG_URL="http://download.osgeo.org/libtiff/${PKG_FILE}" || \
        PKG_URL="http://download.osgeo.org/libtiff/old/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

