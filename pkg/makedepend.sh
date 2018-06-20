#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${MAKEDEPEND_VER}" ] && exit 1

(
    PKG=makedepend
    PKG_VERSION=${MAKEDEPEND_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://xorg.freedesktop.org/releases/individual/util/${PKG_FILE}"
    PKG_DEPS=

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
            --prefix="${PREFIX}"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

