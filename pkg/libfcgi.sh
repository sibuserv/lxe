#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libfcgi
    PKG_VERSION=${LIBFCGI_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=fcgi2-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/FastCGI-Archives/fcgi2/archive/${PKG_VERSION}.tar.gz"
    PKG_DEPS="gcc"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        [ ! -z "${GCC_EXTRA_VER}" ] && export USE_GCC_EXTRA="${GCC_EXTRA_VER}"
        ProcessStandardAutotoolsProject

        # It is very important to unset USE_GCC_EXTRA variable here!
        [ ! -z "${GCC_EXTRA_VER}" ] && unset USE_GCC_EXTRA
    fi
)

