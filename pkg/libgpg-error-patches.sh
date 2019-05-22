#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    [[ "${ARCH}" == i*86 ]] && \
        USE_ARCH=i686 || \
        USE_ARCH=${ARCH}

    if IsPkgVersionGreaterOrEqualTo "1.30"
    then
        cd "${PKG_SRC_DIR}/${SUBDIR}/src/syscfg"
        ln -sf lock-obj-pub.${USE_ARCH}-unknown-linux-gnu.h \
               lock-obj-pub.linux-gnu.h
    elif IsPkgVersionGreaterOrEqualTo "1.19"
    then
        cd "${PKG_SRC_DIR}/${SUBDIR}/src/syscfg"
        ln -sf lock-obj-pub.${USE_ARCH}-pc-linux-gnu.h \
               lock-obj-pub.linux-gnu.h
    fi
)

