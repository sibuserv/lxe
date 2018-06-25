#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=freetype
    PKG_DEPS="freetype-stage1"
    [ ! -z "${HARFBUZZ_VER}" ] && PKG_DEPS="${PKG_DEPS} harfbuzz"

    . "${PKG_DIR}/freetype-common.sh"
)

