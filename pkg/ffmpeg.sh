#!/bin/sh

[ -z "${FFMPEG_VER}" ] && exit 1

(
    PKG=ffmpeg
    PKG_VERSION=${FFMPEG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.bz2
    PKG_URL="http://www.ffmpeg.org/releases/${PKG_FILE}"
    PKG_DEPS="gcc bzip2 yasm zlib"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            --sysroot="${SYSROOT}" \
            ${LIB_TYPE_OPTS} \
            --arch="${ARCH}" \
            --target-os=linux \
            --cross-prefix="${TARGET}-" \
            --enable-cross-compile \
            --enable-avisynth \
            --enable-avresample \
            --disable-debug \
            --disable-doc \
            --disable-libass \
            --disable-libbluray \
            --disable-libbs2b \
            --disable-libcaca \
            --disable-libmp3lame \
            --disable-libopencore-amrnb \
            --disable-libopencore-amrwb \
            --disable-libopus \
            --disable-libspeex \
            --disable-libtheora \
            --disable-libvidstab \
            --disable-libvo-amrwbenc \
            --disable-libvorbis \
            --disable-libvpx \
            --disable-libx264 \
            --disable-libxvid \
            --disable-programs \
            --disable-sdl \
            --disable-iconv \
            --disable-openssl \
            --disable-gnutls \
            --disable-schannel \
            --disable-securetransport

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

