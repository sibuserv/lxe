#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${PKG}" ] && exit 1

(
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR_ORIG}.tar.bz2
    PKG_URL="https://xorg.freedesktop.org/releases/individual/proto/${PKG_FILE}"

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
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

