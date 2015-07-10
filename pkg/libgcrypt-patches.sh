#!/bin/bash

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    if ! IsPkgVersionGreaterOrEqualTo "1.4.5"
    then
        FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile.in"
        FROM_STR="^.* doc tests.*$"
        TO_STR=""
        sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"
    fi
)

