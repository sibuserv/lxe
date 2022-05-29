#!/bin/sh

# All available configs are in "etc/" subdirectory. Select necessary of them:
CONFIGS=""
CONFIGS="${CONFIGS} Ubuntu-14.04_amd64_shared"
CONFIGS="${CONFIGS} Ubuntu-14.04_amd64_static"
CONFIGS="${CONFIGS} Ubuntu-14.04_i386_shared"
CONFIGS="${CONFIGS} Ubuntu-14.04_i386_static"
#CONFIGS="${CONFIGS} AstraLinux-1.5_shared"
#CONFIGS="${CONFIGS} AstraLinux-1.5_static"
#CONFIGS="${CONFIGS} AstraLinux-1.4_shared"
#CONFIGS="${CONFIGS} AstraLinux-1.4_static"
#CONFIGS="${CONFIGS} AstraLinux-1.3_shared"
#CONFIGS="${CONFIGS} AstraLinux-1.3_static"
#CONFIGS="${CONFIGS} AstraLinux-1.2_shared"
#CONFIGS="${CONFIGS} AstraLinux-1.2_static"

# Type of current system:
BUILD="$(LC_ALL=C gcc -v 2>&1 | sed -ne "s|^Target: \(.*\)$|\1|p")"
# BUILD=x86_64-linux-gnu

# Number of compilation processes during building of each package:
JOBS=$(nproc 2>/dev/null || echo 1)
# JOBS=7

# Use ccache tool for (re)building of LXE (false|true):
LXE_USE_CCACHE=false

# Default list of packages:
# LOCAL_PKG_LIST="gcc pkg-config-settings cmake-settings ldd-settings"
# TODO: gstreamer gst-plugins-base
LOCAL_PKG_LIST="cmake-settings ldd-settings boost aspell hunspell libidn2
                minizip miniupnpc tidy-html5 libotr libsignal-protocol-c
                pcre pcre2 lua libfcgi libxss qtbase qttools qtx11extras qca
                qttranslations qtmultimedia qtkeychain qtwebkit"

# List of packages which should provide static libraries in environments with
# shared libraries (see DEFAULT_LIB_TYPE variable in configs):
# STATIC_PKG_LIST="freeglut sdl2 qtbase qwt freeglut protobuf boost proj gdal
#                  openscenegraph osgearth x264 ffmpeg libfcgi"
# STATIC_PKG_LIST="qtbase"

# Override or add extra settings:
EXTRA_SETTINGS_FILE=$(ls "${MAIN_DIR}"/settings.sh.* 2> /dev/null | sort -V | tail -n1)
[ ! -z "${EXTRA_SETTINGS_FILE}" ] && . "${EXTRA_SETTINGS_FILE}" || true

