#!/bin/sh

[ -z "${FREETYPE_VER}" ] && exit 1

(
    PKG=freetype
    PKG_VERSION=${FREETYPE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.bz2
    PKG_URL="http://sourceforge.net/projects/${PKG}/files/freetype2/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings zlib bzip2 libpng"
    [ ! -z "${HARFBUZZ_VER}" ] && PKG_DEPS="${PKG_DEPS} harfbuzz"

    if ! IsPkgInstalled
    then
        [ -z "${HARFBUZZ_VER}" ] && \
            EXTRA_CONFIGURE_OPTS="${EXTRA_CONFIGURE_OPTS}
                                  --without-harfbuzz"
        ProcessStandardAutotoolsProjectInBuildDir \
            --with-gnu-ld \
            ${EXTRA_CONFIGURE_OPTS}

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/${PKG}-config" "${TARGET}-${PKG}-config"
        ln -sf "${TARGET}-${PKG}-config" "${PKG}-config" 
    fi
)

