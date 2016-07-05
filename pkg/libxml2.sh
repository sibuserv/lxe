#!/bin/sh

[ -z "${LIBXML2_VER}" ] && exit 1

(
    PKG=libxml2
    PKG_VERSION=${LIBXML2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="ftp://xmlsoft.org/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigureAutotoolsProject \
            --without-python \
            --without-debug \
            --without-threads

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/xml2-config" "${TARGET}-xml2-config"
        ln -sf "${TARGET}-xml2-config" "xml2-config" 
    fi
)

