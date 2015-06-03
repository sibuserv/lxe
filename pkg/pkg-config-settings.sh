#!/bin/sh

[ -z "${PKGCONFIG_VER}" ] && exit 1

(
    PKG=pkg-config-settings
    PKG_VERSION=${PKGCONFIG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=pkg-config-${PKG_VERSION}
    PKG_FILE=pkg-config-${PKG_VERSION}.tar.gz
    PKG_URL="http://pkgconfig.freedesktop.org/releases/${PKG_FILE}"
    PKG_DEPS=

    if ! IsPkgInstalled
    then
        CheckDependencies

        SetCrossToolchainVariables
        mkdir -p "${PREFIX}/bin"

        cd "${PREFIX}/bin"
        cat > "${TARGET}-pkg-config" << EOF
#!/bin/sh
PKG_CONFIG_SYSROOT_DIR="/" \\
PKG_CONFIG_PATH="${SYSROOT}/usr/lib/pkgconfig" \\
PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig" \\
exec /usr/bin/pkg-config --static "\${@}"
EOF
        chmod uog+x "${TARGET}-pkg-config"
        ln -sf "${TARGET}-pkg-config" "pkg-config"

        date -R > "${INST_DIR}/${PKG}"
        echo "[no-build] ${PKG}"
    fi
)

