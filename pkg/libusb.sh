#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${LIBUSB_VER}" ] || \
(
    PKG=libusb # libusbx libusb-1.0
    PKG_VERSION=${LIBUSB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/libusb/libusb/archive/v${PKG_VERSION}.tar.gz"
    PKG_DEPS="gcc"

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
        GenerateConfigureScript
        ConfigureAutotoolsProject \
            --disable-udev

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

