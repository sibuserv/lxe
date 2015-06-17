#!/bin/sh

[ -z "${GCC_VER}" ] && exit 1

(
    PKG=gcc
    PKG_VERSION=${GCC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=gcc-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/gcc/${PKG_SUBDIR}/${PKG_FILE}"
    PKG_DEPS="glibc pthreads"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGCCBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        unset cc CC cxx CXX
        ( cd "${PREFIX}/bin" && rm -f gcc cpp g++ c++ )
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --target="${TARGET}" \
            --build="${BUILD}" \
            --host="${BUILD}" \
            --with-sysroot="${SYSROOT}" \
            --libdir="${SYSROOT}/usr/lib" \
            --includedir="${SYSROOT}/usr/include" \
            --enable-languages=c,c++ \
            --enable-cloog-backend=isl \
            --enable-threads=posix \
            --enable-static \
            --enable-shared \
            --disable-maintainer-mode \
            --disable-multilib \
            --disable-bootstrap \
            --disable-debug \
            --disable-libmudflap \
            --disable-libssp \
            --disable-libgomp \
            --with-gnu-as \
            --with-gnu-ld \
            libc_cv_forced_unwind=yes \
            libc_cv_ctors_header=yes \
            libc_cv_c_cleanup=yes

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin"
        ln -sf "${TARGET}-gcc" "gcc"
        ln -sf "${TARGET}-cpp" "cpp"
        ln -sf "${TARGET}-g++" "g++"
        ln -sf "${TARGET}-c++" "c++"

        find "${PREFIX}/libexec/gcc" \
             "${SYSROOT}/usr/lib/gcc" \
             -type f  -name '*.la' | \
             while read var; do rm "$var"; done
    fi
)

