#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libidn2
    PKG_VERSION=${LIBIDN2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.lz
    PKG_URL="https://ftp.gnu.org/gnu/libidn/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigureAutotoolsProject \
            --disable-csharp

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

