#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=zlib
    PKG_VERSION=${ZLIB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    # PKG_URL="https://zlib.net/${PKG_FILE}"
    PKG_URL="https://sourceforge.net/projects/libpng/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        IsStaticPackage && \
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

