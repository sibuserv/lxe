#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBOTR_VER}" ] && exit 1

(
    PKG=libotr
    PKG_VERSION=${LIBOTR_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://otr.cypherpunks.ca/${PKG_FILE}"
    PKG_DEPS="gcc libgpg-error libgcrypt"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

