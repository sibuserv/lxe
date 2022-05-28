#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=gcc-stage1
    PKG_VERSION=${GCC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=gcc-${PKG_VERSION}
    PKG_FILE=gcc-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR_ORIG}/${PKG_FILE}"
    PKG_DEPS="glibc-headers"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetGCCBuildFlags
        PrepareGCCConfigureOpts
        UnsetCrossToolchainVariables
        SetCrossToolchainPath
        DeleteGCCSymlinks
        export CXXFLAGS="${CXXFLAGS} --std=c++14"
        ConfigurePkg \
            ${GCC_CONFIGURE_OPTS} \
            --enable-languages=c \
            --enable-static \
            --disable-shared \
            --disable-threads

        IsVer1GreaterOrEqualToVer2 "${LINUX_VER}" "3.13.0" &&
            export NJOBS=${JOBS} ||
            export NJOBS=1

        BuildPkg -j ${NJOBS} all-gcc
        BuildPkg install-gcc
        BuildPkg -j ${NJOBS} all-target-libgcc
        InstallPkg install-target-libgcc

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        cd "${SYSROOT}/usr/lib/gcc/${TARGET}/${GCC_VER}"
        ln -sf "libgcc.a" "libgcc_eh.a"
        # ln -sf "libgcc.a" "libgcc_sh.a"

        cd "${PREFIX}/bin"
        ln -sf "gcc-${GCC_VER}" "gcc"
        ln -sf "cpp-${GCC_VER}" "cpp"
        ln -sf "${TARGET}-gcc-${GCC_VER}" "gcc"
        ln -sf "${TARGET}-cpp-${GCC_VER}" "cpp"
    fi
)

