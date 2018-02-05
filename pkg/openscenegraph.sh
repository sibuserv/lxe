#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${OPENSCENEGRAPH_VER}" ] && exit 1

(
    PKG=openscenegraph
    PKG_VERSION=${OPENSCENEGRAPH_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=OpenSceneGraph-OpenSceneGraph-${PKG_VERSION}
    PKG_FILE=OpenSceneGraph-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/openscenegraph/OpenSceneGraph/archive/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings zlib libpng tiff giflib freetype gdal cmake-settings"
    [ "${USE_JPEG_TURBO}" = "true" ] && PKG_DEPS="${PKG_DEPS} libjpeg-turbo" || \
                                        PKG_DEPS="${PKG_DEPS} jpeg"
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
            -DPKG_CONFIG_EXECUTABLE="${PREFIX}/bin/${TARGET}-pkg-config" \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS} -fpermissive" \
            -DDYNAMIC_OPENTHREADS=OFF \
            -DDYNAMIC_OPENSCENEGRAPH=OFF \
            -DBUILD_OSG_APPLICATIONS=OFF \
            -DOSG_USE_QT=OFF \
            -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

