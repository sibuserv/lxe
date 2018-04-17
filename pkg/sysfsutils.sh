#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${SYSFSUTILS_VER}" ] && exit 1

(
    PKG=sysfsutils
    PKG_VERSION=${SYSFSUTILS_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://sourceforge.net/projects/linux-diag/files/sysfsutils/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
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

