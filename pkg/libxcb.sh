#!/bin/sh

[ -z "${LIBXCB_VER}" ] && exit 1

(
    PKG=libxcb
    PKG_VERSION=${LIBXCB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="https://xcb.freedesktop.org/dist/${PKG_FILE}"
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
        ConfigureAutotoolsProject \
            --disable-build-docs \
            ac_cv_path_XSLTPROC=yes

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

