#!/bin/sh

[ -z "${BINUTILS_VER}" ] && exit 1

(
    PKG=binutils
    PKG_VERSION=${BINUTILS_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS=texinfo

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        export MAKEINFO="${PREFIX}/bin/makeinfo"
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --target="${TARGET}" \
            --build="${BUILD}" \
            --host="${BUILD}" \
            --with-sysroot="${SYSROOT}" \
            --disable-multilib \
            --disable-werror \
            --with-gnu-ld \
            --with-gnu-as \
            --with-gcc

        BuildPkg -j ${JOBS}
        InstallPkg install tooldir="${PREFIX}"

        SetLibraryPath
        BuildPkg -C ld clean
        BuildPkg -C ld LIB_PATH="${LIBRARY_PATH}"
        cp -f "${BUILD_DIR}/${PKG_SUBDIR}/ld/ld-new" \
              "${PREFIX}/bin/${TARGET}-ld"
        UnsetLibraryPath

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin"
        ln -sf "${TARGET}-ld"        "ld"
        ln -sf "${TARGET}-addr2line" "addr2line"
        ln -sf "${TARGET}-c++filt"   "c++filt"
        ln -sf "${TARGET}-elfedit"   "elfedit"
        ln -sf "${TARGET}-gcov"      "gcov"
        ln -sf "${TARGET}-gprof"     "gprof"
        ln -sf "${TARGET}-readelf"   "readelf"
        ln -sf "${TARGET}-size"      "size"
        ln -sf "${TARGET}-strings"   "strings"

        rm -rf "${PREFIX}/lib"/*.la
    fi
)

