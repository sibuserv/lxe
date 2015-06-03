#!/bin/sh

[ -z "${LIBXCB_VER}" ] && exit 1

(
    PKG=libxcb
    PKG_VERSION=${LIBXCB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="http://xcb.freedesktop.org/dist/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings xcb-proto libxslt libxau libxdmcp"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "shared"
        PATH="${PATH}:${SYSROOT}/usr/bin"
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --disable-build-docs

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

