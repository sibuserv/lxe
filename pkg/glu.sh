#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${GLU_VER}" ] || \
(
    PKG=glu
    PKG_VERSION=${GLU_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://freedesktop.org/pub/mesa/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc mesa"

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

