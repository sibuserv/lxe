#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libfcgi
    PKG_VERSION=${LIBFCGI_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-${PKG_VERSION}.orig
    PKG_FILE=${PKG}_${PKG_VERSION}.orig.tar.gz
    PKG_URL="http://ftp.debian.org/debian/pool/main/libf/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        [ ! -z "${GCC_EXTRA_VER}" ] && export USE_GCC_EXTRA="${GCC_EXTRA_VER}"
        ProcessStandardAutotoolsProjectInBuildDir

        # It is very important to unset USE_GCC_EXTRA variable here!
        [ ! -z "${GCC_EXTRA_VER}" ] && unset USE_GCC_EXTRA
    fi
)

