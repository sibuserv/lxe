#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

[ -z "${GLIBC_VER}" ] && exit 1

(
    PKG=ldd-settings
    PKG_DEPS=

    if IsBuildRequired
    then
        CheckDependencies

        SetCrossToolchainVariables
        mkdir -p "${PREFIX}/bin"

        cd "${PREFIX}/bin"
        cat > "${TARGET}-ldd" << EOF
#!/bin/bash
LD_LIBRARY_PATH="${SYSROOT}/usr/lib" \\
exec "/usr/bin/ldd" "\${@}"
EOF
        chmod uog+x "${TARGET}-ldd"
        ln -sf "${TARGET}-ldd" "ldd"

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

