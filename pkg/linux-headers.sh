#!/bin/sh

[ -z "${LINUX_VER}" ] && exit 1

(
    PKG=linux-headers
    PKG_VERSION=${LINUX_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=linux-${PKG_VERSION}
    PKG_FILE=linux-${PKG_VERSION}.tar.xz
    PKG_URL="ftp://ftp.funet.fi/pub/linux/kernel/v${LINUX_SUBVER}/${PKG_FILE}"
    PKG_DEPS=

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        UnsetCrossToolchainVariables

        IsPkgVersionGreaterOrEqualTo "2.6.20" && \
            BuildPkg ARCH=${ARCH} ${ARCH}_defconfig || \
            BuildPkg ARCH=${ARCH} defconfig
        InstallPkg ARCH=${ARCH} headers_install \
            INSTALL_HDR_PATH="${SYSROOT}/usr"

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

