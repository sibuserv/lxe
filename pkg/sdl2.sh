#!/bin/sh

[ -z "${SDL2_VER}" ] && exit 1

(
    PKG=sdl2
    PKG_VERSION=${SDL2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=SDL2-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR_ORIG}.tar.gz
    PKG_URL="http://www.libsdl.org/release/${PKG_FILE}"
    PKG_DEPS="gcc"
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
        PrepareLibTypeOpts "static"
        ConfigureAutotoolsProject \
            --disable-rpath

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

