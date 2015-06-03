#!/bin/sh

[ -z "${BZIP2_VER}" ] && exit 1

(
    PKG=bzip2
    PKG_VERSION=${BZIP2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="http://www.bzip.org/${PKG_VERSION}/${PKG_FILE}"
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
        if [ "${DEFAULT_LIB_TYPE}" = "static" ]
        then
            LIB_NAME="libbz2.a"
            MAKEFILE="Makefile"
        else
            LIB_NAME="all"
            MAKEFILE="Makefile-libbz2_so"
        fi

        BuildPkg -f ${MAKEFILE} ${LIB_NAME} -j ${JOBS} \
            PREFIX="${SYSROOT}/usr" \
            RANLIB="${RANLIB}" \
            CC="${CC}" \
            AR="${AR}"
        InstallPkg -f ${MAKEFILE} library_install \
            PREFIX="${SYSROOT}/usr"

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

