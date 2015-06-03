#!/bin/sh

(
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
        SUBDIR="${PKG_SUBDIR_ORIG}" || \
        SUBDIR="${PKG_SUBDIR}"

    FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile"
    cat >> "${FILE}" << EOF

library_install:
	mkdir -p \$(PREFIX)/include
	mkdir -p \$(PREFIX)/lib
	cp -f bzlib.h \$(PREFIX)/include
	cp -f libbz2.a \$(PREFIX)/lib

EOF

    FILE="${PKG_SRC_DIR}/${SUBDIR}/Makefile-libbz2_so"
    cat >> "${FILE}" << EOF

library_install:
	mkdir -p \$(PREFIX)/include
	mkdir -p \$(PREFIX)/lib
	cp -af bzlib.h \$(PREFIX)/include
	cp -af libbz2.so.1.0 libbz2.so
	cp -af libbz2.so* \$(PREFIX)/lib

EOF
)

