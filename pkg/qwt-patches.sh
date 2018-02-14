#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"

    echo "QWT_CONFIG -= QwtDll QwtDesigner" >> \
         "${PKG_SRC_DIR}/${PKG_SUBDIR}/qwtconfig.pri"
)

