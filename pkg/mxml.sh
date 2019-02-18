#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=mxml
    PKG_VERSION=${MXML_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    IsPkgVersionGreaterOrEqualTo "2.11" && \
        PKG_URL="https://github.com/michaelrsweet/mxml/archive/v${PKG_VERSION}.tar.gz" || \
        PKG_URL="https://github.com/michaelrsweet/mxml/archive/release-${PKG_VERSION}.tar.gz"
    PKG_DEPS="gcc"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        [ ! -z "${GCC_EXTRA_VER}" ] && export USE_GCC_EXTRA="${GCC_EXTRA_VER}"
        ProcessStandardAutotoolsProjectInBuildDir \
            --enable-threads

        # It is very important to unset USE_GCC_EXTRA variable here!
        [ ! -z "${GCC_EXTRA_VER}" ] && unset USE_GCC_EXTRA
    fi
)

