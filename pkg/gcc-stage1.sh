#!/bin/sh

[ -z "${GCC_VER}" ] && exit 1

(
    PKG=gcc-stage1
    PKG_VERSION=${GCC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=gcc-${PKG_VERSION}
    PKG_FILE=gcc-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR_ORIG}/${PKG_FILE}"
    PKG_DEPS="glibc-headers"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGCCBuildFlags
        SetCrossToolchainPath
        UnsetCrossToolchainVariables
        ( cd "${PREFIX}/bin" && rm -f gcc cpp )
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --target="${TARGET}" \
            --build="${BUILD}" \
            --host="${BUILD}" \
            --with-sysroot="${SYSROOT}" \
            --libdir="${SYSROOT}/usr/lib" \
            --includedir="${SYSROOT}/usr/include" \
            --with-headers="${SYSROOT}/usr/include" \
            --enable-languages=c \
            --enable-static \
            --disable-shared \
            --disable-multilib \
            --disable-maintainer-mode \
            --disable-bootstrap \
            --disable-debug \
            --disable-threads \
            --disable-libmudflap \
            --disable-libssp \
            --disable-libgomp \
            --with-gnu-ld \
            --with-gnu-as \
            --without-headers \
            cross_compiling=yes

        BuildPkg all-gcc
        BuildPkg install-gcc
        BuildPkg all-target-libgcc
        InstallPkg install-target-libgcc

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${SYSROOT}/usr/lib/gcc/${TARGET}/${GCC_VER}"
        ln -sf "libgcc.a" "libgcc_eh.a"
        # ln -sf "libgcc.a" "libgcc_sh.a"

        cd "${PREFIX}/bin"
        ln -sf "${TARGET}-gcc" "gcc"
        ln -sf "${TARGET}-cpp" "cpp"
    fi
)

