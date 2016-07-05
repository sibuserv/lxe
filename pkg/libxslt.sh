#!/bin/sh

[ -z "${LIBXSLT_VER}" ] && exit 1

(
    PKG=libxslt
    PKG_VERSION=${LIBXSLT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    PKG_URL="ftp://xmlsoft.org/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings libxml2"
    #  libgcrypt

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
            --without-debug \
            --without-python \
            --without-plugins \
            --without-crypto

        BuildPkg -j ${JOBS} -i -k
        InstallPkg install -i -k

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/xslt-config" "${TARGET}-xslt-config"
        ln -sf "${TARGET}-xslt-config" "xslt-config" 
    fi
)

