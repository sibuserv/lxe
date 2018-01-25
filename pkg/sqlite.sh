#!/bin/sh

[ -z "${SQLITE_VER}" ] && exit 1

(
    PKG=sqlite
    PKG_VERSION=${SQLITE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=SQLite-${SQLITE_FOSSIL_VER}
    PKG_FILE=SQLite-${SQLITE_FOSSIL_VER}.tar.gz
    # https://www.sqlite.org/cgi/src/taglist
    PKG_URL="https://www.sqlite.org/cgi/src/tarball/${PKG_FILE}"
    PKG_DEPS="gcc"

    if ! IsPkgInstalled
    then
        ProcessStandardAutotoolsProject \
            --disable-readline \
            --enable-threadsafe
    fi
)

