#!/bin/sh

[ -z "${LIBGPG_ERROR_VER}" ] && exit 1

(
    PKG=libgpg-error
    PKG_VERSION=${LIBGPG_ERROR_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.gnupg.org/gcrypt/${PKG}/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --disable-nls \
            --disable-languages

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/gpg-error-config" "${TARGET}-gpg-error-config"
        ln -sf "${TARGET}-gpg-error-config" "gpg-error-config" 
    fi
)

