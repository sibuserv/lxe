#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBXKBCOMMON_VER}" ] || \
(
    PKG=libxkbcommon
    PKG_VERSION=${LIBXKBCOMMON_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.xz
    PKG_URL="https://xkbcommon.org/download/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings x11proto-core x11proto-kb libxcb libx11"

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
        PrepareLibTypeOpts "shared"
        PATH="${PATH}:${SYSROOT}/usr/bin"
        ConfigureAutotoolsProject \
            --disable-build-docs

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

