#!/bin/sh

[ -z "${LIBFCGI_VER}" ] && exit 1

(
    PKG=libfcgi
    PKG_VERSION=${LIBFCGI_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-${PKG_VERSION}.orig
    PKG_FILE=${PKG}_${PKG_VERSION}.orig.tar.gz
    PKG_URL="http://ftp.debian.org/debian/pool/main/libf/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "static"
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

