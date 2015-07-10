#!/bin/sh

[ -z "${OPENSSL_VER}" ] && exit 1

(
    PKG=openssl
    PKG_VERSION=${OPENSSL_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    [ "${OPENSSL_SUBVER}" = "${OPENSSL_VER}" ] &&
        PKG_URL="ftp://ftp.openssl.org/source/${PKG_FILE}" ||
        PKG_URL="ftp://ftp.openssl.org/source/old/${OPENSSL_SUBVER}/${PKG_FILE}"
    PKG_DEPS="gcc zlib libgcrypt"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        [ "${DEFAULT_LIB_TYPE}" = "static" ] && \
            LIB_TYPE_OPTS="no-shared" || \
            LIB_TYPE_OPTS="shared"
        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        ln -sf "config" "configure"
        unset CROSS_COMPILE
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LIB_TYPE_OPTS} \
            no-capieng \
            zlib

        BuildPkg all
        InstallPkg install_sw

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

