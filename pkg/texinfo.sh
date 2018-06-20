#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${TEXINFO_VER}" ] && exit 1

(
    PKG=texinfo
    PKG_VERSION=${TEXINFO_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
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

