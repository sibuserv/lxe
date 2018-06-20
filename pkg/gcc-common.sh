#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${PKG}" ] && exit 1

(
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    [ "${PKG_VERSION}" = "${GCC_EXTRA_VER}" ] && \
        PKG_FILE=gcc-${PKG_VERSION}.tar.xz || \
        PKG_FILE=gcc-${PKG_VERSION}.tar.bz2
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR_ORIG}/${PKG_FILE}" || \
        PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR}/${PKG_FILE}"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetGCCBuildFlags "${PKG_VERSION}"
        PrepareGCCConfigureOpts "${PKG_VERSION}"
        SetCrossToolchainVariables "${PKG_VERSION}"
        SetCrossToolchainPath
        DeleteGCCSymlinks
        unset cc CC cxx CXX
        ConfigurePkg \
            ${GCC_CONFIGURE_OPTS} \
            --enable-languages=c,c++ \
            --enable-cloog-backend=isl \
            --enable-threads=posix \
            --enable-static \
            --enable-shared

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks "${PKG_VERSION}"
        UpdateGCCSymlinks "${GCC_VER}"

        DIR="${SYSROOT}/usr/lib/gcc/${TARGET}"
        mv -f "${DIR}"/lib*/* "${DIR}/${PKG_VERSION}/" 2> /dev/null
        rmdir "${DIR}"/lib* 2> /dev/null

        DIR_2="${PREFIX}/${TARGET}"
        if [ -d "${DIR_2}" ]
        then
            mv -f "${DIR_2}"/lib*/* "${DIR}/${PKG_VERSION}/" 2> /dev/null
            rmdir "${DIR_2}"/lib* 2> /dev/null
            rmdir "${DIR_2}" 2> /dev/null
        fi

        find "${PREFIX}/libexec/gcc" "${SYSROOT}/usr/lib/gcc" \
             -type f -name '*.la' -exec rm -f {} \;
    fi
)

