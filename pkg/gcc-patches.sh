#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    if [ "$(ls "${PKG_SRC_DIR}/${SUBDIR}"/gmp-*.tar.* 2>/dev/null | wc -l)" = "0" ]
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/bootstrap.log"
        cd "${PKG_SRC_DIR}/${SUBDIR}"
        # Get GCC embedded libraries:
        ./contrib/download_prerequisites &> "${LOG_FILE}"
        CheckFail "${LOG_FILE}"
    fi
)

