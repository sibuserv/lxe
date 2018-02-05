#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${FREETYPE_VER}" ] && exit 1

(
    PKG=freetype
    PKG_DEPS="freetype-stage1"
    [ ! -z "${HARFBUZZ_VER}" ] && PKG_DEPS="${PKG_DEPS} harfbuzz"

    . "${PKG_DIR}/freetype-common.sh"
)

