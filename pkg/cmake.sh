#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=cmake
    PKG_VERSION=${CMAKE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=cmake-${PKG_VERSION}
    PKG_FILE=cmake-${PKG_VERSION}.tar.gz
    PKG_URL="https://www.cmake.org/files/v${CMAKE_SUBVER}/${PKG_FILE}"
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
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --mandir="${PREFIX}/share/man"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

