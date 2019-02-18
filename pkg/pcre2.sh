#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=pcre2
    PKG_VERSION=${PCRE2_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://ftp.pcre.org/pub/pcre/${PKG_FILE}"
    PKG_DEPS="gcc"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        [ ! -z "${GCC_EXTRA_VER}" ] && export USE_GCC_EXTRA="${GCC_EXTRA_VER}"
        ProcessStandardAutotoolsProject \
            --enable-pcre2-16 \
            --enable-utf \
            --enable-unicode-properties \
            --enable-cpp \
            --disable-pcre2grep-libz \
            --disable-pcre2grep-libbz2 \
            --disable-pcre2test-libreadline

        # It is very important to unset USE_GCC_EXTRA variable here!
        [ ! -z "${GCC_EXTRA_VER}" ] && unset USE_GCC_EXTRA

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config"
    fi
)

