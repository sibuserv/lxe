#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=miniupnpc
    PKG_VERSION=${MINIUPNPC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=miniupnp-miniupnpc_$(echo "${PKG_VERSION}" | sed -e "s;\.;_;g")
    PKG_FILE=${PKG}_$(echo "${PKG_VERSION}" | sed -e "s;\.;_;g").tar.gz
    PKG_URL="https://github.com/miniupnp/miniupnp/archive/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        UpdateCmakeSymlink "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureCmakeProject \
            "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/miniupnpc" \
            -DUPNPC_BUILD_STATIC="${CMAKE_STATIC_BOOL}" \
            -DUPNPC_BUILD_SHARED="${CMAKE_SHARED_BOOL}" \
            -DUPNPC_BUILD_TESTS=OFF \
            -DUPNPC_BUILD_SAMPLE=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

