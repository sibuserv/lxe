#!/bin/sh

[ -z "${BOOST_VER}" ] && exit 1

(
    PKG=boost
    PKG_VERSION=${BOOST_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=boost_$(echo "${PKG_VERSION}" | tr '.' '_')
    PKG_FILE=${PKG_SUBDIR_ORIG}.tar.bz2
    PKG_URL="https://sourceforge.net/projects/${PKG}/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc bzip2 expat zlib"
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

        cd "${BUILD_DIR}/${PKG_SUBDIR}/tools/build"
        ./bootstrap.sh &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        CheckFail "${LOG_DIR}/${PKG_SUBDIR}/configure.log"

        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        ./tools/build/b2 \
            -a \
            -q \
            -j ${JOBS} \
            link=static \
            threading=multi \
            variant=release \
            --layout=tagged \
            --disable-icu \
            --without-mpi \
            --without-python \
            --prefix="${SYSROOT}/usr" \
            --exec-prefix="${SYSROOT}/usr/bin" \
            --libdir="${SYSROOT}/usr/lib" \
            --includedir="${SYSROOT}/usr/include" \
            -sEXPAT_INCLUDE="${SYSROOT}/usr/include" \
            -sEXPAT_LIBPATH="${SYSROOT}/usr/lib" \
            install \
            &>> "${LOG_DIR}/${PKG_SUBDIR}/make-install.log"
        CheckFail "${LOG_DIR}/${PKG_SUBDIR}/make-install.log"

        DeleteExtraFiles
        EndOfPkgBuild

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

