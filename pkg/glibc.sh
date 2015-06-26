#!/bin/sh

[ -z "${GLIBC_VER}" ] && exit 1

(
    PKG=glibc
    PKG_VERSION=${GLIBC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS="texinfo gcc-stage1"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGlibcBuildFlags
        SetCrossToolchainPath
        PrepareGlibcConfigureOpts
        SetCrossToolchainVariables
        unset cxx CXX
        ConfigurePkg \
            ${LXE_CONFIGURE_OPTS} \
            ${GLIBC_CONFIGURE_OPTS}

        BuildPkg
        IsPkgVersionGreaterOrEqualTo "2.16.0" && \
            InstallPkg install DESTDIR="${SYSROOT}" || \
            InstallPkg install install_root="${SYSROOT}"

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

