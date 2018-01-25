#!/bin/sh

[ -z "${OPENCV_VER}" ] && exit 1

(
    PKG=opencv
    PKG_VERSION=${OPENCV_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.zip
    #PKG_URL="https://github.com/Itseez/opencv/archive/${PKG_FILE}"
    PKG_URL="https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings"
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
            -DBUILD_TESTS=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DWITH_OPENEXR=OFF \
            -DBUILD_OPENEXR=OFF \
            -DWITH_TIFF=OFF \
            -DBUILD_TIFF=OFF \
            -DENABLE_PRECOMPILED_HEADERS=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

