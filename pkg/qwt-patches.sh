#!/bin/sh

(
    cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"

    PATCH_FILE="${PKG_DIR}/${PKG}-${PKG_VERSION}.patch"
    if [ -e "${PATCH_FILE}" ]
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        patch -p1 --binary -i "${PATCH_FILE}" &> "${LOG_FILE}"
    fi

    echo "QWT_CONFIG -= QwtDll QwtDesigner" >> \
         "${PKG_SRC_DIR}/${PKG_SUBDIR}/qwtconfig.pri"
)

