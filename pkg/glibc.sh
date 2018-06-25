#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=glibc
    PKG_VERSION=${GLIBC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS="texinfo gcc-stage1"

    CheckPkgVersion
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

        # Workaround for rare problem of build of old glibc versions.
        # Search for "glibc-2.*/shlib.lds:.*: syntax error" bug for
        # more details.
        export LANGUAGE=""
        export LC_ALL="C"
        #

        unset cxx CXX
        ConfigurePkg \
            ${LXE_CONFIGURE_OPTS} \
            ${GLIBC_CONFIGURE_OPTS}

        BuildGlibc -j ${JOBS}
        IsPkgVersionGreaterOrEqualTo "2.16.0" && \
            InstallPkg install DESTDIR="${SYSROOT}" || \
            InstallPkg install install_root="${SYSROOT}"

        CleanPkgBuildDir
        CleanPkgSrcDir

        unset LC_ALL
    fi
)

