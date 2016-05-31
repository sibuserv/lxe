#!/bin/sh

[ -z "${PROTOBUF_VER}" ] && exit 1

(
    PKG=protobuf
    PKG_VERSION=${PROTOBUF_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    # PKG_URL="https://github.com/google/${PKG}/archive/v${PKG_VERSION}.tar.gz"
    PKG_URL="https://github.com/google/protobuf/releases/download/v${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        # cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
        # ./autogen.sh &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --with-zlib

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)
