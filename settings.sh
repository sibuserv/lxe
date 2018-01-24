#!/bin/sh

# All available configs are in "etc/" subdirectory. Select necessary of them:
CONFIGS="
        AstraLinux-1.4_static
        AstraLinux-1.4_shared
        AstraLinux-1.3_static
        AstraLinux-1.3_shared
        AstraLinux-1.2_static
        Ubuntu-14.04-LTS_amd64_static
        Ubuntu-14.04-LTS_amd64_shared
        Ubuntu-14.04-LTS_i386_static
        Ubuntu-14.04-LTS_i386_shared
        "

# CONFIGS="Ubuntu-14.04-LTS_amd64_static Ubuntu-14.04-LTS_i386_static"
# CONFIGS="Ubuntu-14.04-LTS_amd64_shared Ubuntu-14.04-LTS_i386_shared"
# CONFIGS="AstraLinux-1.4_static AstraLinux-1.3_static AstraLinux-1.2_static"
# CONFIGS="AstraLinux-1.4_shared AstraLinux-1.3_shared"


# Type of current system:
BUILD="$(LC_ALL=C gcc -v 2>&1 | sed -ne "s|^Target: \(.*\)$|\1|p")"
# BUILD=x86_64-linux-gnu

# Number of compilation processes during building of each package:
JOBS=$(nproc 2>/dev/null || echo 1)
# JOBS=4

# Default list of packages:
# LOCAL_PKG_LIST="gcc pkg-config-settings cmake-settings ldd-settings"
LOCAL_PKG_LIST="cmake-settings ldd-settings freeglut sdl2 qtbase qtconnectivity
                qtscript qtserialport qtsvg qttools qtwebsockets qwt protobuf
                libjpeg-turbo boost ffmpeg openscenegraph osgearth"

# Delete unpacked source files after successful build of the package (true/false):
CLEAN_SRC_DIR=true

# Delete files from "build/" sub-directory after successful build of the package (true/false):
CLEAN_BUILD_DIR=true

# Override or add extra settings:
EXTRA_SETTINGS_FILE=$(ls "${MAIN_DIR}"/settings.sh.* 2> /dev/null | sort -V | tail -n1)
[ ! -z "${EXTRA_SETTINGS_FILE}" ] && . "${EXTRA_SETTINGS_FILE}" || true

