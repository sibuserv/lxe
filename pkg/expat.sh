#!/bin/sh

[ -z "${EXPAT_VER}" ] && exit 1

(
    PKG=expat
    PKG_VERSION=${EXPAT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    IsPkgVersionGreaterOrEqualTo "2.1.1" && \
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2 || \
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://sourceforge.net/projects/${PKG}/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

