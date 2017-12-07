#!/bin/sh

[ -z "${MXML_VER}" ] && exit 1

(
    PKG=mxml
    PKG_VERSION=${MXML_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://github.com/michaelrsweet/mxml/archive/v${PKG_VERSION}.tar.gz"
    PKG_DEPS="gcc"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        PrepareLibTypeOpts "static"
        ConfigureAutotoolsProjectInBuildDir \
            --enable-threads

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

