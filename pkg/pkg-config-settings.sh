#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=pkg-config-settings
    PKG_DEPS=

    if IsBuildRequired
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
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

