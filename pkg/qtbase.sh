#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qtbase
    PKG_VERSION=${QT5_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    if IsPkgVersionGreaterOrEqualTo "5.10.0"
    then
        PKG_SUBDIR_ORIG=${PKG}-everywhere-src-${PKG_VERSION}
        PKG_FILE=${PKG}-everywhere-src-${PKG_VERSION}.tar.xz
    else
        PKG_SUBDIR_ORIG=${PKG}-opensource-src-${PKG_VERSION}
        PKG_FILE=${PKG}-opensource-src-${PKG_VERSION}.tar.xz
    fi
    PKG_URL="https://download.qt.io/archive/qt/${QT5_SUBVER}/${QT5_VER}/submodules/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings zlib libpng giflib freetype fontconfig openssl
              sqlite pcre2 libxcb libx11 libxkbcommon libxext libxi libxrender libxrandr mesa"
    [ "${USE_JPEG_TURBO}" = "true" ] && PKG_DEPS="${PKG_DEPS} libjpeg-turbo" || \
                                        PKG_DEPS="${PKG_DEPS} jpeg"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        IsStaticPackage && \
            LIB_TYPE_OPTS="-static" || \
            LIB_TYPE_OPTS="-shared"
        export LD=${CROSS_COMPILE}g++

        [ -z "${HARFBUZZ_VER}" ] && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -no-harfbuzz"
        if [ -z "${LIBXKBCOMMON_VER}" ]
        then
            IsPkgVersionGreaterOrEqualTo "5.5.0" && \
                EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                      -qt-xkbcommon-x11 \
                                      -no-xkbcommon-evdev" || \
                EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                      -qt-xkbcommon"
        fi
        IsPkgVersionGreaterOrEqualTo "5.5.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -system-pcre" || \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -qt-pcre"
        ! IsPkgVersionGreaterOrEqualTo "5.7.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -c++11"
        ! IsPkgVersionGreaterOrEqualTo "5.7.1" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -no-nis"
        ! IsPkgVersionGreaterOrEqualTo "5.11.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -no-qml-debug \
                                  -no-pulseaudio \
                                  -no-alsa"
        ! IsPkgVersionGreaterOrEqualTo "5.12.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS} \
                                  -no-xinput2"
        export OPENSSL_LIBS="$(${TARGET}-pkg-config --libs-only-l openssl)"
        ConfigurePkg \
            -xplatform "linux-g++-${SYSTEM}" \
            -device-option CROSS_COMPILE="${TARGET}-" \
            -device-option SYSTEM_ROOT_DIR="${SYSROOT}" \
            -device-option PKG_CONFIG="${TARGET}-pkg-config" \
            -extprefix "${SYSROOT}/qt5" \
            -sysroot "${SYSROOT}" \
            ${LIB_TYPE_OPTS} \
            -confirm-license \
            -opensource \
            -release \
            -strip \
            -pkg-config \
            -opengl desktop \
            -nomake examples \
            -nomake tests \
            -plugin-sql-sqlite \
            -qt-xcb \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -system-freetype \
            -fontconfig \
            -openssl-linked \
            -accessibility \
            -no-compile-examples \
            -no-optimized-qmake \
            -no-use-gold-linker \
            -no-pch \
            -no-rpath \
            -no-cups \
            -no-kms \
            -no-egl \
            -no-eglfs \
            -no-directfb \
            -no-linuxfb \
            -no-openvg \
            -no-glib \
            -no-xcb-xlib \
            -no-iconv \
            -no-libudev \
            -no-evdev \
            -no-icu \
            -no-mtdev \
            -no-journald \
            -no-sql-sqlite2 \
            -no-sql-mysql \
            -no-sql-psql \
            -no-sql-odbc \
            -no-sql-tds \
            -no-sql-oci \
            -no-sql-db2 \
            -no-sql-ibase \
            ${EXTRA_CONFIGURE_OPTS} \
            -verbose

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        unset LD OPENSSL_LIBS

        find "${SYSROOT}/qt5/lib" -type f -name '*.la' -exec rm -f {} \;
    fi
)

