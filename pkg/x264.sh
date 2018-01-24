#!/bin/sh

[ -z "${X264_VER}" ] && exit 1

(
    PKG=x264
    PKG_VERSION=${X264_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-snapshot-${PKG_VERSION}
    PKG_FILE=${PKG}-snapshot-${PKG_VERSION}.tar.bz2
    PKG_URL="https://download.videolan.org/pub/videolan/${PKG}/snapshots/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProject \
            --cross-prefix="${TARGET}-" \
            --disable-asm \
            --disable-lavf \
            --disable-swscale
    fi
)

