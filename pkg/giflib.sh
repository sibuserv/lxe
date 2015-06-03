#!/bin/sh

[ -z "${GIFLIB_VER}" ] && exit 1

(
    PKG=giflib
    PKG_VERSION=${GIFLIB_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    if IsPkgVersionGreaterOrEqualTo "5.0.0"
    then
        PKG_URL="http://sourceforge.net/projects/${PKG}/files/giflib-5.x/${PKG_FILE}"
    else
        PKG_URL="http://sourceforge.net/projects/${PKG}/files/giflib-4.x/${PKG_SUBDIR}/${PKG_FILE}"
    fi
    PKG_DEPS="gcc zlib jpeg"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS}

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

