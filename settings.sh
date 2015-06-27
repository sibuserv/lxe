#!/bin/sh

# CONFIGS="Ubuntu-14.04-LTS_i386_static Ubuntu-14.04-LTS_amd64_static"
CONFIGS="Ubuntu-14.04-LTS_i386_shared Ubuntu-14.04-LTS_amd64_shared"
# CONFIGS="AstraLinux-1.2_static"
# CONFIGS="AstraLinux-1.2_shared AstraLinux-1.3_shared AstraLinux-1.4_shared"
# CONFIGS="МСВС-3.0-80001-16_shared"
# CONFIGS="МСВС-3.0-80001-12_shared МСВС-3.0-80001-16_shared МСВС-5.0_shared"

# Type of current system:
BUILD="$(LC_ALL=C gcc -v 2>&1 | sed -ne "s|^Target: \(.*\)$|\1|p")"
# BUILD=x86_64-linux-gnu

# Number of compilation processes during building of each package:
JOBS=4

# Default list of packages:
# LOCAL_PKG_LIST="gcc pkg-config-settings cmake-settings ldd-settings"
LOCAL_PKG_LIST="qt5 openscenegraph freeglut ldd-settings"

# Delete unpacked source files after successful build of the package (true/false):
CLEAN_SRC_DIR=true

# Delete files from "build/" sub-directory after successful build of the package (true/false):
CLEAN_BUILD_DIR=true

