#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=qtwebkit
    PKG_VERSION=${QTWEBKIT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-${QTWEBKIT_GIT_VER}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="https://github.com/qt/qtwebkit/archive/${QTWEBKIT_GIT_VER}.tar.gz"
    PKG_DEPS="gcc cmake-settings libxml2 libxslt icu sqlite qtbase qtmultimedia
              qtquickcontrols qtsensors qtwebchannel"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        if IsStaticPackage
        then
            date -R > "${INST_DIR}/${PKG}"
            echo "[config]   ${CONFIG}"
            echo "[no-build] ${PKG}"
            exit 0
        fi

        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        UpdateCmakeSymlink "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureCmakeProject \
            -DPKG_CONFIG_EXECUTABLE="${PREFIX}/bin/${TARGET}-pkg-config" \
            -DEGPF_DEPS='Qt5Core Qt5Gui Qt5Multimedia Qt5Widgets Qt5WebKit' \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS} -fpermissive" \
            -DCMAKE_SYSTEM_PREFIX_PATH="${SYSROOT}/qt5" \
            -DCMAKE_INSTALL_PREFIX="${SYSROOT}/qt5" \
            -DCMAKE_SYSTEM_PROCESSOR="${ARCH}" \
            -DPORT=Qt \
            -DENABLE_X11_TARGET=OFF \
            -DENABLE_GEOLOCATION=OFF \
            -DENABLE_MEDIA_SOURCE=ON \
            -DENABLE_VIDEO=ON \
            -DENABLE_WEB_AUDIO=ON \
            -DUSE_GSTREAMER=OFF \
            -DUSE_QT_MULTIMEDIA=ON \
            -DUSE_LIBHYPHEN=OFF

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
        UpdateCmakeSymlink
    fi
)

