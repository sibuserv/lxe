#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=osgearth
    PKG_VERSION=${OSGEARTH_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=osgearth-osgearth-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/gwaldron/osgearth/archive/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings curl gdal openscenegraph sqlite tinyxml2 zlib"
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
            -DDYNAMIC_OSGEARTH="${CMAKE_SHARED_BOOL}" \
            -DWITH_EXTERNAL_TINYXML=OFF \
            -DBUILD_OSGEARTH_EXAMPLES=OFF \
            -DBUILD_APPLICATIONS=OFF \
            -DBUILD_TESTS=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

