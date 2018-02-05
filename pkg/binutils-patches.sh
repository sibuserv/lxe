#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    if [ "${BINUTILS_VER}" = "2.18" ]
    then
        [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
            SUBDIR="${PKG_SUBDIR_ORIG}" || \
            SUBDIR="${PKG_SUBDIR}"

        FROM_STR="texinfo\[^0-9\]\*(\[1-3\]\[0-9\]|4\\\.\[4-9\]|\[5-9\])"
        TO_STR="texinfo\[^0-9\]\*(\.\*)"
        FILE="${PKG_SRC_DIR}/${SUBDIR}/configure"
        sed -i "${FILE}" -e "s;${FROM_STR};${TO_STR};"
    fi
)

