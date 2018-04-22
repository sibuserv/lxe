#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${GLIBC_VER}" ] && exit 1

(
    PKG=glibc-headers
    PKG_VERSION=${GLIBC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=glibc-${PKG_VERSION}
    PKG_FILE=glibc-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/glibc/${PKG_FILE}"
    PKG_DEPS="binutils make linux-headers"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetGlibcBuildFlags
        SetCrossToolchainPath
        PrepareGlibcConfigureOpts
        SetCrossToolchainVariables
        unset cc CC cxx CXX
        ConfigurePkg \
            ${LXE_CONFIGURE_OPTS} \
            ${GLIBC_CONFIGURE_OPTS}

        IsPkgVersionGreaterOrEqualTo "2.16.0" && \
            InstallPkg install-headers DESTDIR="${SYSROOT}" || \
            InstallPkg install-headers install_root="${SYSROOT}"

        CleanPkgBuildDir
        CleanPkgSrcDir

        touch "${SYSROOT}/usr/include/gnu/stubs.h"
        touch "${SYSROOT}/usr/include/gnu/stubs-64.h"
        touch "${SYSROOT}/usr/include/bits/stdio_lim.h"
    fi
)

