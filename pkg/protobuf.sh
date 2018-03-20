#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${PROTOBUF_VER}" ] && exit 1

(
    PKG=protobuf
    PKG_VERSION=${PROTOBUF_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://github.com/google/protobuf/archive/v${PKG_VERSION}.tar.gz"

    PKG_DEPS="gcc zlib"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath

        cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
        ./autogen.sh &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        CheckFail "${LOG_FILE}"
        ConfigureAutotoolsProject \
            --with-zlib

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

