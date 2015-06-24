#!/bin/sh

[ -z "${GLIBC_VER}" ] && exit 1

(
    PKG=glibc-headers
    PKG_VERSION=${GLIBC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=glibc-${PKG_VERSION}
    PKG_FILE=glibc-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/glibc/${PKG_FILE}"
    PKG_DEPS="binutils make linux-headers"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGlibcBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        unset cc CC cxx CXX
        ConfigurePkg \
            --prefix="/usr" \
            ${LXE_CONFIGURE_OPTS} \
            --with-headers="${SYSROOT}/usr/include" \
            --enable-kernel="${LINUX_VER}" \
            libc_cv_ssp=no \
            libc_cv_c_cleanup=yes \
            libc_cv_ctors_header=yes \
            libc_cv_forced_unwind=yes \
            libc_cv_gcc_builtin_expect=yes \
            cross_compiling=yes

        IsPkgVersionGreaterOrEqualTo "2.16.0" && \
            InstallPkg install-headers DESTDIR="${SYSROOT}" -i -k || \
            InstallPkg install-headers install_root="${SYSROOT}" -i -k

        CleanPkgBuildDir
        CleanPkgSrcDir

        touch "${SYSROOT}/usr/include/gnu/stubs.h"
        touch "${SYSROOT}/usr/include/gnu/stubs-64.h"
        touch "${SYSROOT}/usr/include/bits/stdio_lim.h"
    fi
)

