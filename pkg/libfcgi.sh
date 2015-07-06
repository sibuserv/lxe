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
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        PrepareLibTypeOpts "static"
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS}

        BuildPkg
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

