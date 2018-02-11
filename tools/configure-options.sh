#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

PrepareConfigureOpts()
{
    LXE_CONFIGURE_OPTS="--build=${BUILD} --target=${TARGET} --host=${TARGET}"
}

PrepareGlibcConfigureOpts()
{
    GLIBC_CONFIGURE_OPTS="
        --prefix=/usr \
        --with-headers=${SYSROOT}/usr/include \
        --with-binutils=${PREFIX}/bin \
        --enable-kernel=${LINUX_VER} \
        --disable-profile \
        --disable-debug \
        --without-selinux \
        libc_cv_ssp=no \
        libc_cv_c_cleanup=yes \
        libc_cv_ctors_header=yes \
        libc_cv_forced_unwind=yes \
        libc_cv_gcc_builtin_expect=yes \
        cross_compiling=yes"
}

PrepareGCCConfigureOpts()
{
    [ ! -z "${1}" ] && \
        GCC_CURRENT_VER=${1} || \
        GCC_CURRENT_VER=${GCC_VER}

    GCC_CONFIGURE_OPTS="
        --prefix=${PREFIX} \
        --target=${TARGET} \
        --build=${BUILD} \
        --host=${BUILD} \
        --program-suffix=-${GCC_CURRENT_VER} \
        --with-sysroot=${SYSROOT} \
        --libdir=${SYSROOT}/usr/lib \
        --includedir=${SYSROOT}/usr/include \
        --with-gxx-include-dir=${SYSROOT}/usr/include/c++/${PKG_VERSION} \
        --with-slibdir=${SYSROOT}/usr/lib/gcc/${TARGET}/${PKG_VERSION} \
        --enable-version-specific-runtime-libs \
        --enable-libgomp \
        --disable-multilib \
        --disable-maintainer-mode \
        --disable-bootstrap \
        --disable-debug \
        --disable-libmudflap \
        --disable-libssp \
        --with-gnu-ld \
        --with-gnu-as \
        libc_cv_forced_unwind=yes \
        libc_cv_ctors_header=yes \
        libc_cv_c_cleanup=yes"
}

PrepareLibTypeOpts()
{
    if [ ! -z "${1}" ]
    then
        local LIB_TYPE="${1}"
    elif IsStaticPackage
    then
        local LIB_TYPE="static"
    else
        local LIB_TYPE="shared"
    fi

    if [ "${LIB_TYPE}" = "static" ]
    then
        LIB_TYPE_OPTS="--enable-static --disable-shared"
        AUTOTOOLS_STATIC_STR="--enable-static"
        AUTOTOOLS_SHARED_STR="--disable-shared"
        CMAKE_STATIC_BOOL="ON"
        CMAKE_SHARED_BOOL="OFF"
    elif [ "${LIB_TYPE}" = "both" ]
    then
        LIB_TYPE_OPTS="--enable-static --enable-shared"
        AUTOTOOLS_STATIC_STR="--enable-static"
        AUTOTOOLS_SHARED_STR="--enable-shared"
        CMAKE_STATIC_BOOL="ON"
        CMAKE_SHARED_BOOL="ON"
    else
        LIB_TYPE_OPTS="--enable-shared --disable-static"
        AUTOTOOLS_STATIC_STR="--disable-static"
        AUTOTOOLS_SHARED_STR="--enable-shared"
        CMAKE_STATIC_BOOL="OFF"
        CMAKE_SHARED_BOOL="ON"
    fi
}

