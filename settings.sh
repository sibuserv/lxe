#!/bin/sh

# All available configs are in "etc/" subdirectory. Select necessary of them:
# CONFIGS="
#         AstraLinux-1.5_static
#         AstraLinux-1.5_shared
#         AstraLinux-1.4_static
#         AstraLinux-1.4_shared
#         AstraLinux-1.3_static
#         AstraLinux-1.3_shared
#         AstraLinux-1.2_static
#         AstraLinux-1.2_shared
#         Ubuntu-14.04_amd64_static
#         Ubuntu-14.04_amd64_shared
#         Ubuntu-14.04_i386_static
#         Ubuntu-14.04_i386_shared
#         "

# CONFIGS="AstraLinux-1.5_static AstraLinux-1.4_static AstraLinux-1.3_static"
# CONFIGS="AstraLinux-1.5_shared AstraLinux-1.3_shared"
# CONFIGS="Ubuntu-14.04_amd64_static Ubuntu-14.04_i386_static"
CONFIGS="Ubuntu-14.04_amd64_shared Ubuntu-14.04_i386_shared"


# Type of current system:
BUILD="$(LC_ALL=C gcc -v 2>&1 | sed -ne "s|^Target: \(.*\)$|\1|p")"
# BUILD=x86_64-linux-gnu

# Number of compilation processes during building of each package:
JOBS=$(nproc 2>/dev/null || echo 1)
# JOBS=7

# Default list of packages:
# LOCAL_PKG_LIST="gcc pkg-config-settings cmake-settings ldd-settings"
# TODO: hunspell minizip miniupnpc qtkeychain qtwebkit gstreamer gst-plugins-base lua
LOCAL_PKG_LIST="cmake-settings ldd-settings boost aspell libotr tidy-html5
                libsignal-protocol-c qtbase qttools qtmultimedia qca"

# List of packages which should provide static libraries in environments with
# shared libraries (see DEFAULT_LIB_TYPE variable in configs):
# STATIC_PKG_LIST="freeglut sdl2 qt4 qtbase qwt freeglut protobuf boost proj gdal
#                  openscenegraph osgearth x264 ffmpeg libfcgi"
# STATIC_PKG_LIST="qtbase"

# Delete unpacked source files after successful build of the package (true/false):
CLEAN_SRC_DIR=true

# Delete files from "build/" sub-directory after successful build of the package (true/false):
CLEAN_BUILD_DIR=true

# Override or add extra settings:
EXTRA_SETTINGS_FILE=$(ls "${MAIN_DIR}"/settings.sh.* 2> /dev/null | sort -V | tail -n1)
[ ! -z "${EXTRA_SETTINGS_FILE}" ] && . "${EXTRA_SETTINGS_FILE}" || true

