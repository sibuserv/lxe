#!/bin/sh

[ -z "${FREETYPE_VER}" ] && exit 1

(
    PKG=freetype
    PKG_DEPS="freetype-stage1"
    [ ! -z "${HARFBUZZ_VER}" ] && PKG_DEPS="${PKG_DEPS} harfbuzz"

    . "${PKG_DIR}/freetype-common.sh"
)

