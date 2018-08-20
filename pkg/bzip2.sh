#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=bzip2
    PKG_VERSION=${BZIP2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://web.archive.org/web/20180801004107/http://www.bzip.org/${PKG_VERSION}/${PKG_FILE}"
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
        SetCrossToolchainPath
        SetCrossToolchainVariables
        if IsStaticPackage
        then
            LIB_NAME="libbz2.a"
            MAKEFILE="Makefile"
        else
            LIB_NAME="all"
            MAKEFILE="Makefile-libbz2_so"
        fi

        BuildPkg -f ${MAKEFILE} ${LIB_NAME} -j ${JOBS} \
            PREFIX="${SYSROOT}/usr" \
            RANLIB="${RANLIB}" \
            CC="${CC}" \
            AR="${AR}"
        InstallPkg -f ${MAKEFILE} library_install \
            PREFIX="${SYSROOT}/usr"

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

