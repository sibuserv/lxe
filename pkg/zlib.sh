#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${ZLIB_VER}" ] && exit 1

(
    PKG=zlib
    PKG_VERSION=${ZLIB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    # PKG_URL="http://zlib.net/${PKG_FILE}"
    PKG_URL="https://sourceforge.net/projects/libpng/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        [ "${DEFAULT_LIB_TYPE}" = "static" ] && \
            LIB_TYPE_OPTS="--static" || \
            LIB_TYPE_OPTS="--shared"
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LIB_TYPE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

