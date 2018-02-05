#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${TIDY_HTML5_VER}" ] && exit 1

(
    PKG=tidy-html5
    PKG_VERSION=${TIDY_HTML5_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz
    PKG_URL="https://github.com/htacg/tidy-html5/archive/${PKG_VERSION}.tar.gz"
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
            -DTIDY_COMPAT_HEADERS:BOOL=YES \
            -DBUILD_SHARED_LIB=${CMAKE_SHARED_BOOL}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink

        if [ "${DEFAULT_LIB_TYPE}" = "static" ]
        then
            mv "${SYSROOT}/usr/lib/libtidys.a" \
               "${SYSROOT}/usr/lib/libtidy.a"
        else
            rm -f "${SYSROOT}/usr/lib/libtidys.a"
        fi
    fi
)

