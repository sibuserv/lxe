#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qca
    PKG_VERSION=${QCA_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/KDE/qca/archive/v${PKG_VERSION}.tar.gz"
    # PKG_URL="https://download.kde.org/stable/qca/${PKG_VERSION}/src/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings qtbase"
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
            -DCMAKE_SYSTEM_PREFIX_PATH="${SYSROOT}/qt5" \
            -DBUILD_SHARED_LIBS="${CMAKE_SHARED_BOOL}" \
            -DBUILD_STATIC_LIBS="${CMAKE_STATIC_BOOL}" \
            -DBUILD_TESTS=OFF \
            -DBUILD_TOOLS=OFF \
            -DUSE_RELATIVE_PATHS=OFF \
            -DBUILD_PLUGINS="auto"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

