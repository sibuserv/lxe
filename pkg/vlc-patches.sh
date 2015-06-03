#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    if IsPkgVersionGreaterOrEqualTo "2.1.0"
    then
        CONTRIB_DIR="${PKG_SRC_DIR}/${SUBDIR}/contrib/${SYSTEM}"
        if [ ! -d "${PKG_SRC_DIR}/${SUBDIR}/contrib/${SYSTEM}" ]
        then
            LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/bootstrap.log"
            mkdir -p "${CONTRIB_DIR}"
            cd "${CONTRIB_DIR}"
            ../bootstrap \
                --prefix="${SYSROOT}/usr" \
                --host="x86_64-linux-gnu" \
                 &> "${LOG_FILE}"
            CheckFail "${LOG_FILE}"

            LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/autoreconf.log"
            cd "${PKG_SRC_DIR}/${SUBDIR}"
            autoreconf -fi &> "${LOG_FILE}"
            CheckFail "${LOG_FILE}"
        fi
    fi
)

