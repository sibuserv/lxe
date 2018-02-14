#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${FREETYPE_VER}" ] && exit 1

(
    PKG=freetype-stage1
    PKG_VERSION=${FREETYPE_VER}
    PKG_SUBDIR_ORIG=freetype-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings zlib bzip2 libpng"

    . "${PKG_DIR}/freetype-common.sh"
)

