#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    FROM_STR="pkgconfigdir = \$(datadir)/pkgconfig"
    TO_STR="pkgconfigdir = \$(libdir)/pkgconfig"

    FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile.am"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!"

    FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile.in"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!"
)

