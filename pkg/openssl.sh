#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=openssl
    PKG_VERSION=${OPENSSL_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://ftp.openssl.org/source/${PKG_FILE}"
    PKG_URL_2="https://ftp.openssl.org/source/old/${OPENSSL_SUBVER}/${PKG_FILE}"
    PKG_DEPS="gcc zlib libgcrypt"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        IsStaticPackage && \
            LIB_TYPE_OPTS="no-shared" || \
            LIB_TYPE_OPTS="shared"
        [[ "${ARCH}" == i*86 ]] && \
            OPENSSL_TARGET="linux-generic32 -DL_ENDIAN" || \
            OPENSSL_TARGET="linux-${ARCH}"
        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        ln -sf "Configure" "configure"
        unset CROSS_COMPILE
        export LD_LIBRARY_PATH="${SYSROOT}/usr/lib"
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${OPENSSL_TARGET} \
            ${LIB_TYPE_OPTS} \
            -Wa,--noexecstack \
            zlib

        BuildPkg all
        InstallPkg install_sw

        CleanPkgBuildDir
        CleanPkgSrcDir

        unset LD_LIBRARY_PATH
    fi
)

