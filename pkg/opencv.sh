#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=opencv
    PKG_VERSION=${OPENCV_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.zip
    #PKG_URL="https://github.com/Itseez/opencv/archive/${PKG_FILE}"
    PKG_URL="https://sourceforge.net/projects/opencvlibrary/files/opencv-unix/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc cmake-settings zlib bzip2 jpeg libpng"
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
            -DCMAKE_INSTALL_PREFIX="${SYSROOT}/usr" \
            -DBUILD_SHARED_LIBS="${CMAKE_SHARED_BOOL}" \
            -DBUILD_STATIC_LIBS="${CMAKE_STATIC_BOOL}" \
            -DCMAKE_CXX_FLAGS="" \
            -DCMAKE_C_FLAGS="" \
            -DCMAKE_SHARED_LINKER_FLAGS="" \
            -DCMAKE_EXE_LINKER_FLAGS="" \
            -DENABLE_PRECOMPILED_HEADERS=OFF \
            -DCMAKE_VERBOSE=ON \
            -DWITH_QT=OFF \
            -DWITH_OPENGL=ON \
            -DWITH_OPENEXR=OFF \
            -DWITH_GSTREAMER=OFF \
            -DWITH_FFMPEG=OFF \
            -DWITH_XINE=OFF \
            -DWITH_GTK=OFF \
            -DWITH_TIFF=OFF \
            -DBUILD_opencv_apps=OFF \
            -DBUILD_DOCS=OFF \
            -DBUILD_EXAMPLES=OFF \
            -DBUILD_PACKAGE=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DBUILD_TESTS=OFF \
            -DBUILD_WITH_DEBUG_INFO=OFF \
            -DBUILD_FAT_JAVA_LIB=OFF \
            -DBUILD_ZLIB=OFF \
            -DBUILD_TIFF=OFF \
            -DBUILD_JASPER=OFF \
            -DBUILD_JPEG=OFF \
            -DBUILD_WEBP=OFF \
            -DBUILD_PNG=OFF \
            -DBUILD_OPENEXR=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

