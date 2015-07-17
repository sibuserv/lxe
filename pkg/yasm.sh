#!/bin/sh

[ -z "${YASM_VER}" ] && exit 1

(
    PKG=yasm
    PKG_VERSION=${YASM_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="http://www.tortall.net/projects/${PKG}/releases/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --disable-nls

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cp -af "${PREFIX}/include"/libyasm* "${SYSROOT}/usr/include/"
        rm -rf "${PREFIX}/include"/libyasm*
        find "${PREFIX}/include" -depth -empty -delete
    fi
)

