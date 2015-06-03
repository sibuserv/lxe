#!/bin/sh

[ -z "${GLIBC_VER}" ] && exit 1

(
    PKG=glibc
    PKG_VERSION=${GLIBC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="ftp://ftp.funet.fi/pub/gnu/prep/${PKG}/${PKG_FILE}"
    PKG_DEPS="texinfo gcc-stage1"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGlibcBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        # unset cxx CXX
        ConfigurePkg \
            --prefix="/usr" \
            ${LXE_CONFIGURE_OPTS} \
            --with-headers="${SYSROOT}/usr/include" \
            --with-binutils="${PREFIX}/bin" \
            --enable-kernel="${LINUX_VER}" \
            --disable-profile \
            --disable-debug \
            --without-selinux \
            libc_cv_forced_unwind=yes \
            libc_cv_ctors_header=yes \
            libc_cv_c_cleanup=yes \
            cross_compiling=yes

        BuildPkg
        InstallPkg install_root="${SYSROOT}" install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

