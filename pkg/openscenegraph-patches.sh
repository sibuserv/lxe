#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    PATCH_FILE="${PKG_DIR}/openscenegraph-${PKG_VERSION}.patch"
    if [ -e "${PATCH_FILE}" ]
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        cd "${PKG_SRC_DIR}/${SUBDIR}"
        patch -p1 -i "${PATCH_FILE}" &> "${LOG_FILE}"
    fi
)

