#!/bin/sh

[ -z "${PKG}" ] && exit 1

(
    PKG_VERSION=${FREETYPE_VER}
    PKG_SUBDIR=freetype-${PKG_VERSION}
    PKG_FILE=freetype-${PKG_VERSION}.tar.bz2
    PKG_URL="http://sourceforge.net/projects/freetype/files/freetype2/${PKG_VERSION}/${PKG_FILE}"

    if ! IsPkgInstalled
    then
        if [ "${PKG}" = "freetype-stage1" ]
        then
            EXTRA_CONFIGURE_OPTS="--without-harfbuzz"
        else
            if [ ! -z "${HARFBUZZ_VER}" ]
            then
                EXTRA_CONFIGURE_OPTS="--with-harfbuzz=yes"
            else
                EXTRA_CONFIGURE_OPTS="--without-harfbuzz"
            fi
        fi

        ProcessStandardAutotoolsProjectInBuildDir \
            --with-gnu-ld \
            ${EXTRA_CONFIGURE_OPTS}

        cd "${PREFIX}/bin/"
        ln -sf "${SYSROOT}/usr/bin/freetype-config" "${TARGET}-freetype-config"
        ln -sf "${TARGET}-freetype-config" "freetype-config"
    fi
)

