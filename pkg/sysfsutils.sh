#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${SYSFSUTILS_VER}" ] || \
(
    PKG=sysfsutils
    PKG_VERSION=${SYSFSUTILS_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://sourceforge.net/projects/linux-diag/files/sysfsutils/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

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
        IsStaticPackage && \
            PrepareLibTypeOpts "both"
        ConfigureAutotoolsProjectInBuildDir

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

