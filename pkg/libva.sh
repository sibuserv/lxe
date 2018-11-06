#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=libva
    PKG_VERSION=${LIBVA_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://github.com/intel/libva/archive/${PKG_FILE}"
    PKG_DEPS="gcc libx11 libxext libxfixes mesa"

    CheckPkgVersion
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
        # https://trac.ffmpeg.org/ticket/5920
        PrepareLibTypeOpts "shared"
        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        autoreconf -vfi &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        ConfigureAutotoolsProjectInBuildDir \
            "${EXTRA_CONFIGURE_OPTS}"

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

