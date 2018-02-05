#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    # Disable tests after build of libraries:
    FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile.in"
    FROM_STR="tests"
    TO_STR=""
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"
)

