#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=expat
    PKG_VERSION=${EXPAT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    if IsPkgVersionGreaterOrEqualTo "2.4.5"
    then
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.lz
    elif [ ${PKG_VERSION} = "2.2.9" ]
    then
        PKG_FILE=${PKG}-${PKG_VERSION}-RENAMED-VULNERABLE-PLEASE-USE-2.4.1-INSTEAD.tar.bz2
    elif [ ${PKG_VERSION} = "2.2.6" ]
    then
        PKG_FILE=${PKG}-${PKG_VERSION}-RENAMED-VULNERABLE-PLEASE-USE-2.4.7-INSTEAD.tar.bz2
    elif [ ${PKG_VERSION} = "2.1.0" ]
    then
        PKG_FILE=${PKG}-${PKG_VERSION}-RENAMED-VULNERABLE-PLEASE-USE-2.3.0-INSTEAD.tar.gz
    elif [ ${PKG_VERSION} = "2.0.1" ]
    then
        PKG_FILE=${PKG}-${PKG_VERSION}-RENAMED-VULNERABLE-PLEASE-USE-2.4.7-INSTEAD.tar.gz
    else
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    fi
    PKG_URL="https://sourceforge.net/projects/${PKG}/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

