#!/bin/sh

(
    if [ "${JPEG_VER}" = "6b" ]
    then
        [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
            SUBDIR="${PKG_SUBDIR_ORIG}" || \
            SUBDIR="${PKG_SUBDIR}"

        FROM_STR="./libtool"
        TO_STR="libtool --tag=CC"
        FILE="${PKG_SRC_DIR}/${SUBDIR}/configure"
        sed -i "${FILE}" -e "s;${FROM_STR};${TO_STR};"

        mkdir -p "${SYSROOT}/usr/man/man1"
    fi
)

