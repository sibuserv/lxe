#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    FROM_STR=
    TO_STR="    *\.*)"
    FILE="${PKG_SRC_DIR}/${SUBDIR}/configure"
    # Fix tests for newer versions of:
    # as, ld
    # make
    # makeinfo
    # sed
    # gcc
    for FROM_STR in \
        "    2.1\[3-9\]\*)" \
        "    3\.79\* | 3\.\[89\]\*)" \
        "    4\.\*)" \
        "    3\.0\[2-9\]\*|3\.\[1-9\]\*|\[4-9\]\*)" \
        "    3\.4\* | 4\.\[0-9\]\* )"
    do
        sed -i "${FILE}" -e "s;${FROM_STR};${TO_STR};"
    done

    FROM_STR="-isystem \\\$ccheaders "
    TO_STR="-isystem \\\${ccheaders} -isystem \\\${ccheaders}-fixed "
    FILE="${PKG_SRC_DIR}/${SUBDIR}/configure"
    sed -i "${FILE}" -e "s;${FROM_STR};${TO_STR};"

    FROM_STR="GNU sed version "
    TO_STR="sed (GNU sed) "
    FILE="${PKG_SRC_DIR}/${SUBDIR}/configure"
    sed -i "${FILE}" -e "s;${FROM_STR};${TO_STR};"

    # https://sourceware.org/ml/crossgcc/2009-05/msg00014.html
    FROM_STR="= 0 + SIZEOF_HEADERS;"
    TO_STR="= .* + SIZEOF_HEADERS;"
    FILE="${PKG_SRC_DIR}/${SUBDIR}/elf/Makefile"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!"

    FROM_STR="install-others-programs = \$(inst_libexecdir)/pt_chown"
    TO_STR=""
    FILE="${PKG_SRC_DIR}/${SUBDIR}/login/Makefile"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!"

    if IsPkgVersionGreaterOrEqualTo "2.16.0"
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        cd "${PKG_SRC_DIR}/${SUBDIR}"
        patch -p1 -i "${PKG_DIR}/glibc-2.16.0.patch" &> "${LOG_FILE}"
    fi
)

