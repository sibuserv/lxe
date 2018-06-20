#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBDRM_VER}" ] && exit 1

(
    PKG=libdrm
    PKG_VERSION=${LIBDRM_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://dri.freedesktop.org/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings expat libpciaccess"

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
        IsStaticPackage && \
            PrepareLibTypeOpts "both"
        ConfigureAutotoolsProject \
            --disable-udev \
            --with-gnu-ld

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

