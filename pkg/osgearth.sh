#!/bin/sh

[ -z "${OSGEARTH_VER}" ] && exit 1

(
    PKG=osgearth
    PKG_VERSION=${OSGEARTH_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=osgearth-osgearth-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/gwaldron/osgearth/archive/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings curl gdal openscenegraph sqlite tinyxml2 zlib"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        # -DDYNAMIC_OSGEARTH=${CMAKE_SHARED_BOOL} \
        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        UpdateCmakeSymlink "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureCmakeProject \
            -DWITH_EXTERNAL_TINYXML=ON \
            -DDYNAMIC_OSGEARTH=OFF \
            -DBUILD_OSGEARTH_EXAMPLES=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

