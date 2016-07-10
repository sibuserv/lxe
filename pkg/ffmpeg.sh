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
            --disable-programs \
            --disable-sdl \
            --disable-libx264

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

