#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qtwebkit
    PKG_VERSION=${QTWEBKIT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-${QTWEBKIT_GIT_VER}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/qt/qtwebkit/archive/${QTWEBKIT_GIT_VER}.tar.gz"
    PKG_DEPS="gcc cmake-settings icu sqlite qtbase qtmultimedia qtquickcontrols"
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
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureQmakeProject \
            "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/WebKit.pro"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        find "${SYSROOT}/qt5/lib" -type f -name '*.la' -exec rm -f {} \;
    fi
)

