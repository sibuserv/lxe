#!/bin/sh

[ -z "${PKG}" ] && exit 1

(
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        PKG_FILE=${PKG_SUBDIR_ORIG}.tar.bz2 || \
        PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="http://xorg.freedesktop.org/releases/individual/lib/${PKG_FILE}"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        [ "${DEFAULT_LIB_TYPE}" = "static" ] && \
            PrepareLibTypeOpts "both"
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --enable-malloc0returnsnull

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

