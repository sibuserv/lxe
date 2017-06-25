#!/bin/sh

[ -z "${QT5_VER}" ] && exit 1

(
    PKG=qtbase
    PKG_VERSION=${QT5_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-opensource-src-${PKG_VERSION}
    PKG_FILE=${PKG}-opensource-src-${PKG_VERSION}.tar.xz
    PKG_URL="http://download.qt.io/archive/qt/${QT5_SUBVER}/${QT5_VER}/submodules/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings zlib libpng jpeg freetype fontconfig
              openssl sqlite libxcb libx11 libxext libxi libxrender libxrandr
              mesa"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        export LD=${CROSS_COMPILE}g++
        IsPkgVersionGreaterOrEqualTo "5.5.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS}
                                  -qt-xkbcommon-x11
                                  -no-xkbcommon-evdev" || \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS}
                                  -qt-xkbcommon"
        ! IsPkgVersionGreaterOrEqualTo "5.7.0" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS}
                                  -c++11"
        ! IsPkgVersionGreaterOrEqualTo "5.7.1" && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS}
                                  -no-nis"
        export OPENSSL_LIBS="$(${TARGET}-pkg-config --libs-only-l openssl)"
        ConfigurePkg \
            -xplatform "linux-g++-${SYSTEM}" \
            -device-option CROSS_COMPILE="${TARGET}-" \
            -device-option SYSTEM_ROOT_DIR="${SYSROOT}" \
            -device-option PKG_CONFIG="${TARGET}-pkg-config" \
            -extprefix "${SYSROOT}/qt5" \
            -sysroot "${SYSROOT}" \
            -confirm-license \
            -opensource \
            -continue \
            -static \
            -release \
            -strip \
            -pkg-config \
            -opengl desktop \
            -nomake examples \
            -nomake tests \
            -plugin-sql-sqlite \
            -pch \
            -qt-pcre \
            -qt-xcb \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -system-freetype \
            -fontconfig \
            -openssl-linked \
            -no-kms \
            -no-egl \
            -no-eglfs \
            -no-directfb \
            -no-linuxfb \
            -no-openvg \
            -no-glib \
            -no-xinput2 \
            -no-xcb-xlib \
            -no-harfbuzz \
            -no-qml-debug \
            -no-rpath \
            -no-cups \
            -no-iconv \
            -no-libudev \
            -no-evdev \
            -no-icu \
            -no-dbus \
            -no-mtdev \
            -no-journald \
            -no-accessibility \
            -no-compile-examples \
            -no-sql-sqlite2 \
            -no-sql-mysql \
            -no-sql-psql \
            -no-sql-odbc \
            -no-sql-tds \
            -no-sql-oci \
            -no-sql-db2 \
            -no-sql-ibase \
            -no-optimized-qmake \
            -no-use-gold-linker \
            -no-pulseaudio \
            -no-alsa \
            -no-pch \
            ${EXTRA_CONFIGURE_OPTS} \
            -v
#             -platform "linux-g++-${SYSTEM}" \
#             -no-gcc-sysroot \

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        unset LD OPENSSL_LIBS

        find "${SYSROOT}/qt5/lib" -type f -name '*.la' -exec rm -f {} \;
    fi
)

