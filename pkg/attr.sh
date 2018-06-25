#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=attr
    PKG_VERSION=${ATTR_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.src.tar.gz
    PKG_URL="https://download.savannah.nongnu.org/releases/attr/${PKG_FILE}"
    PKG_DEPS="gcc libgpg-error libgcrypt"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

