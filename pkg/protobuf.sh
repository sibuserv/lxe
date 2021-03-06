#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=protobuf
    PKG_VERSION=${PROTOBUF_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="https://github.com/google/protobuf/releases/download/v${PKG_VERSION}/protobuf-cpp-${PKG_VERSION}.tar.gz"
    PKG_DEPS="gcc zlib"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources

        cd "${PKG_SRC_DIR}"
        cp -aT "${PKG_SUBDIR}" "${PKG_SUBDIR}-native-build"

        # Native build
        PKG_SUBDIR=${PKG}-${PKG_VERSION}-native-build
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --enable-static \
            --disable-shared

        BuildPkg -j ${JOBS}
        cp -a "${BUILD_DIR}/${PKG_SUBDIR}/src/protoc" "${PREFIX}/bin/"

        CleanPkgBuildDir
        CleanPkgSrcDir
        # End of native build

        PKG_SUBDIR=${PKG}-${PKG_VERSION}
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        if IsVer1GreaterOrEqualToVer2 "${LIBTOOL_VER}" "2.4.2"
        then
            cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
            ./autogen.sh &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
            CheckFail "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        fi
        ConfigureAutotoolsProject \
            --with-zlib

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

