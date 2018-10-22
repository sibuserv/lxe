#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=lua
    PKG_VERSION=${LUA_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://www.lua.org/ftp/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainVariables
        SetCrossToolchainPath

        BuildPkg -j ${JOBS} \
            INSTALL_TOP="${SYSROOT}/usr" \
            CC="${CC}" \
            RANLIB="${RANLIB}" \
            MYCFLAGS="${CFLAGS}" \
            MYLDFLAGS="${LDFLAGS}" \
            linux
        InstallPkg -j 1 \
            INSTALL_TOP="${SYSROOT}/usr" \
            install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

