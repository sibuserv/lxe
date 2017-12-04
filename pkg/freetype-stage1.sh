#!/bin/sh

[ -z "${FREETYPE_VER}" ] && exit 1

(
    PKG=freetype-stage1
    PKG_DEPS="gcc pkg-config-settings zlib bzip2 libpng"

    . "${PKG_DIR}/freetype-common.sh"
)

