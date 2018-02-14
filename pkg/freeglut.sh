#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${FREEGLUT_VER}" ] && exit 1

(
    PKG=freeglut
    PKG_VERSION=${FREEGLUT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://sourceforge.net/projects/${PKG}/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc mesa libxi cmake-settings"
    [ ! -z "${GLU_VER}" ] && PKG_DEPS="${PKG_DEPS} glu"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        if IsPkgVersionGreaterOrEqualTo "3.0.0"
        then
            UpdateCmakeSymlink
            ConfigureCmakeProject \
                -DFREEGLUT_BUILD_SHARED_LIBS="${CMAKE_SHARED_BOOL}" \
                -DFREEGLUT_BUILD_STATIC_LIBS="${CMAKE_STATIC_BOOL}" \
                -DFREEGLUT_REPLACE_GLUT=ON \
                -DFREEGLUT_GLES=OFF \
                -DFREEGLUT_BUILD_DEMOS=OFF
        else
            ConfigureAutotoolsProject \
                --with-sysroot="${SYSROOT}" \
                --enable-replace-glut \
                --disable-debug \
                --with-gnu-ld
        fi

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

