#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    if IsPkgVersionGreaterOrEqualTo "5.0.0" && ! IsPkgVersionGreaterOrEqualTo "5.1.1"
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        cd "${PKG_SRC_DIR}/${SUBDIR}"
        patch -p1 -i "${PKG_DIR}/gcc-5.1.0.patch" &> "${LOG_FILE}"
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

