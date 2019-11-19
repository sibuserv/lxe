#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=texinfo
    PKG_VERSION=${TEXINFO_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS=
    [ "${LXE_USE_CCACHE}" = "true" ] && PKG_DEPS="ccache ${PKG_DEPS}"

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
            --disable-info \
            --disable-man

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

