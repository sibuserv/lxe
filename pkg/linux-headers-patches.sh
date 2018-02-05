#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    if ! IsPkgVersionGreaterOrEqualTo "2.6.20"
    then
        FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile"
        cat >> "${FILE}" << EOF

headers_install:
	mkdir -p "\$(INSTALL_HDR_PATH)/include"
	cp -avT "include/asm-\$(ARCH)" \\
		"\$(INSTALL_HDR_PATH)/include/asm"
	cp -avT "include/asm-generic" \\
		"\$(INSTALL_HDR_PATH)/include/asm-generic"
	cp -avT "include/linux" \\
		"\$(INSTALL_HDR_PATH)/include/linux"

EOF
    fi
)

