#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${UDEV_VER}" ] || \
(
    PKG=udev
    PKG_VERSION=${UDEV_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://mirrors.edge.kernel.org/pub/linux/utils/kernel/hotplug/${PKG_FILE}"
    PKG_DEPS="gcc pciutils usbutils"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "shared"
        ConfigureAutotoolsProject \
            --with-pci-ids-path="${SYSROOT}/usr/share/misc" \
            --disable-gudev \
            --disable-introspection \
            --disable-keymap

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

