#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=xcb-proto
    PKG_VERSION=${XCB_PROTO_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="https://xcb.freedesktop.org/dist/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings libxml2"

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
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

