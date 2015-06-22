#!/bin/sh

[ -z "${VLC_VER}" ] && exit 1

(
    PKG=vlc
    PKG_VERSION=${VLC_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    IsPkgVersionGreaterOrEqualTo "2.0.0" && \
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz || \
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="http://download.videolan.org/pub/videolan/vlc/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc mesa"
    # glew

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetGlibcBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            --enable-shared \
            --disable-static \
            --disable-gles1 \
            --disable-gles2 \
            --disable-libxml2 \
            --disable-libgcrypt \
            --disable-avformat \
            --disable-swscale \
            --disable-avcodec \
            --disable-opus \
            --disable-opensles \
            --disable-taglib \
            --disable-zvbi \
            --disable-libass \
            --disable-mod \
            --disable-mad \
            --disable-vorbis \
            --disable-dvbpsi \
            --disable-dvdread \
            --disable-dvdnav \
            --disable-mkv \
            --disable-live555 \
            --disable-realrtsp \
            --disable-vlc \
            --disable-nls \
            --disable-update-check \
            --disable-vlm \
            --disable-dbus \
            --disable-lua \
            --disable-vcd \
            --disable-v4l2 \
            --disable-gnomevfs \
            --disable-bluray \
            --disable-linsys \
            --disable-decklink \
            --disable-libva \
            --disable-dv1394 \
            --disable-sid \
            --disable-gme \
            --disable-tremor \
            --disable-dca \
            --disable-sdl-image \
            --disable-fluidsynth \
            --disable-jack \
            --disable-pulse \
            --disable-alsa \
            --disable-samplerate \
            --disable-sdl \
            --disable-xcb \
            --disable-atmo \
            --disable-qt \
            --disable-skins2 \
            --disable-mtp \
            --disable-notify \
            --disable-svg \
            --disable-udev \
            --disable-caca \
            --disable-goom \
            --disable-projectm \
            --disable-sout \
            --disable-faad \
            --disable-x264 \
            --disable-schroedinger \
            --disable-a52 \
            \
            --disable-nls \
            --disable-mozilla \
            --disable-postproc \
            --disable-fribidi \
            --disable-bonjour \
            --disable-remoteosd

        BuildPkg -j ${JOBS} -i -k
        InstallPkg install -i -k

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

