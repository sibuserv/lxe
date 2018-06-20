#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${USBUTILS_VER}" ] || \
(
    PKG=usbutils
    PKG_VERSION=${USBUTILS_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz
    PKG_URL="https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/${PKG_FILE}"
    PKG_DEPS="gcc libusb"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "shared"
        ConfigureAutotoolsProject \
            --datarootdir="${SYSROOT}/usr/lib" \
            --disable-gudev \
            --disable-introspection

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

