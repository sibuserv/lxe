#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    PATCH_FILE="${PKG_DIR}/gcc-${PKG_VERSION}.patch"
    if [ -e "${PATCH_FILE}" ]
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        cd "${PKG_SRC_DIR}/${SUBDIR}"
        patch -p1 -i "${PATCH_FILE}" &> "${LOG_FILE}"
    fi

    if [ "$(ls "${PKG_SRC_DIR}/${SUBDIR}"/gmp-*.tar.* 2>/dev/null | wc -l)" = "0" ]
    then
        if IsPkgVersionGreaterOrEqualTo "4.6.0"
        then
            LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/bootstrap.log"
            cd "${PKG_SRC_DIR}/${SUBDIR}"
            # Get GCC embedded libraries:
            ./contrib/download_prerequisites &> "${LOG_FILE}"
            CheckFail "${LOG_FILE}"
        fi
    fi
)

