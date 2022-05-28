#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=make
    PKG_VERSION=${MAKE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS=

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        # Fix build with GCC 10 and newer:
        export CFLAGS="${CFLAGS} -fcommon"
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --disable-info \
            --disable-man \
            --enable-static \
            --disable-shared

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

