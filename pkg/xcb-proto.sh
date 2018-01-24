#!/bin/sh

[ -z "${XCB_PROTO_VER}" ] && exit 1

(
    PKG=xcb-proto
    PKG_VERSION=${XCB_PROTO_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="https://xcb.freedesktop.org/dist/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings libxml2"

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
            ${LXE_CONFIGURE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

