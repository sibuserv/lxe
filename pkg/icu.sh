#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=icu
    PKG_VERSION=${ICU_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}
    PKG_FILE=icu4c-$(echo "${ICU_VER}" | sed -e "s;\.;_;g")-src.tgz
    PKG_URL="http://download.icu-project.org/files/icu4c/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources

        cd "${PKG_SRC_DIR}"
        cp -aT "${PKG_SUBDIR_ORIG}/source" "${PKG_SUBDIR}"
        cp -aT "${PKG_SUBDIR_ORIG}/source" "${PKG_SUBDIR}-native-build"
        rm -rf "${PKG_SUBDIR_ORIG}"
        unset PKG_SUBDIR_ORIG

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
        # End of native build

        PKG_SUBDIR=${PKG}-${PKG_VERSION}
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigureAutotoolsProject \
            --with-cross-build="${BUILD_DIR}/${PKG_SUBDIR}-native-build"
        BuildPkg -j ${JOBS} VERBOSE=1
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        rm -rf "${BUILD_DIR}/${PKG_SUBDIR}-native-build"
        rm -rf "${PKG_SRC_DIR}/${PKG}-${PKG_VERSION}-native-build"

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config"
    fi
)

