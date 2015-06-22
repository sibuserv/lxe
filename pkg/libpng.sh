#!/bin/sh

[ -z "${LIBPNG_VER}" ] && exit 1

(
    PKG=libpng
    PKG_VERSION=${LIBPNG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    IsPkgVersionGreaterOrEqualTo "1.2.52" && \
        PKG_URL="http://sourceforge.net/projects/${PKG}/files/libpng12/${PKG_VERSION}/${PKG_FILE}" || \
        PKG_URL="http://sourceforge.net/projects/${PKG}/files/libpng12/older-releases/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

