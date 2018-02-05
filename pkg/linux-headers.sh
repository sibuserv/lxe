#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

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

        [[ "${ARCH}" == i*86 ]] && \
            KERNEL_ARCH=i386 || \
            KERNEL_ARCH=${ARCH}
        IsPkgVersionGreaterOrEqualTo "2.6.20" && \
            BuildPkg ARCH=${KERNEL_ARCH} ${KERNEL_ARCH}_defconfig || \
            BuildPkg ARCH=${KERNEL_ARCH} defconfig
        InstallPkg ARCH=${KERNEL_ARCH} headers_install \
            INSTALL_HDR_PATH="${SYSROOT}/usr"

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

