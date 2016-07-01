#!/bin/sh

[ -z "${OPENCV_VER}" ] && exit 1

(
    PKG=opencv
    PKG_VERSION=${OPENCV_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_VERSION}.zip
    PKG_URL="https://github.com/Itseez/opencv/archive/${PKG_FILE}"
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
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureCmakeProject \
            -DCMAKE_INSTALL_PREFIX="${SYSROOT}/usr" \
            -DCMAKE_BUILD_TYPE=Release \
            -DBUILD_TESTS=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DWITH_OPENEXR=OFF \
            -DBUILD_OPENEXR=OFF \
            -DWITH_TIFF=OFF \
            -DBUILD_TIFF=OFF \
            -DBUILD_SHARED_LIBS=OFF \
            -DENABLE_PRECOMPILED_HEADERS=OFF \
            "${PKG_SRC_DIR}/${PKG_SUBDIR}"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

