#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${HARFBUZZ_VER}" ] || \
(
    PKG=harfbuzz
    PKG_VERSION=${HARFBUZZ_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="https://www.freedesktop.org/software/${PKG}/release/${PKG_FILE}"
    PKG_DEPS="gcc freetype-stage1"

    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        ProcessStandardAutotoolsProject
    fi
)

