#!/bin/sh

[ -z "${ATTR_VER}" ] && exit 1

(
    PKG=attr
    PKG_VERSION=${ATTR_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.src.tar.gz
    PKG_URL="https://download.savannah.nongnu.org/releases/attr/${PKG_FILE}"
    PKG_DEPS="gcc libgpg-error libgcrypt"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProjectInBuildDir
    fi
)

