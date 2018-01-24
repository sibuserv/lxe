#!/bin/sh

(
    cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"

    echo "QWT_CONFIG -= QwtDll QwtDesigner" >> \
         "${PKG_SRC_DIR}/${PKG_SUBDIR}/qwtconfig.pri"
)

