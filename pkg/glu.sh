#!/bin/sh

[ -z "${GLU_VER}" ] || \
(
    PKG=glu
    PKG_VERSION=${GLU_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://freedesktop.org/pub/mesa/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc mesa"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        [ "${DEFAULT_LIB_TYPE}" = "static" ] && \
            PrepareLibTypeOpts "both"
        ConfigureAutotoolsProjectInBuildDir

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

