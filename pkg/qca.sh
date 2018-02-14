#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${QCA_VER}" ] && exit 1

(
    PKG=qca
    PKG_VERSION=${QCA_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/KDE/qca/archive/v${PKG_VERSION}.tar.gz"
    # PKG_URL="https://download.kde.org/stable/qca/${PKG_VERSION}/src/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings qtbase"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        UpdateCmakeSymlink "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureCmakeProject \
            -DCMAKE_SYSTEM_PREFIX_PATH="${SYSROOT}/qt5" \
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

