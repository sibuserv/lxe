#!/bin/sh

[ -z "${PKG}" ] && exit 1

(
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=gcc-${PKG_VERSION}.tar.bz2
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR_ORIG}/${PKG_FILE}" || \
        PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR}/${PKG_FILE}"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        if [ "${ARCH}" = x86_64 ]
        then
            mkdir -p "${PREFIX}/${TARGET}/lib"
            ln -snf "lib" "${PREFIX}/${TARGET}/lib64"
        fi

        SetGCCBuildFlags "${PKG_VERSION}"
        PrepareGCCConfigureOpts "${PKG_VERSION}"
        SetCrossToolchainVariables "${PKG_VERSION}"
        SetCrossToolchainPath
        DeleteGCCSymlinks
        unset cc CC cxx CXX
        ConfigurePkg \
            ${GCC_CONFIGURE_OPTS} \
            --enable-languages=c,c++ \
            --enable-cloog-backend=isl \
            --enable-threads=posix \
            --enable-static \
            --enable-shared

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        DIR="${PREFIX}/${TARGET}/include"
        [ -d "${DIR}" ] && \
            cp -afT "${DIR}" "${SYSROOT}/usr/include" && \
            rm -rf "${DIR}" 2> /dev/null

        DIR="${PREFIX}/${TARGET}/lib"
        [ -d "${DIR}" ] && \
            mv -f "${DIR}"/* "${SYSROOT}/usr/lib/gcc/${TARGET}/${PKG_VERSION}/" && \
            rmdir "${DIR}" 2> /dev/null

        [ "${ARCH}" = x86_64 ] && \
            rm -f "${PREFIX}/${TARGET}/lib64" 2> /dev/null

        rmdir "${PREFIX}/${TARGET}" 2> /dev/null

        find "${PREFIX}/libexec/gcc" \
             "${SYSROOT}/usr/lib/gcc" \
             -type f  -name '*.la' | \
             while read F; do rm "${F}"; done
    fi
)

