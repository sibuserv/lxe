#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=ccache
    PKG_VERSION=${CCACHE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.xz
    PKG_URL="https://github.com/ccache/ccache/releases/download/v${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS=

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetSystemPath
        UnsetCrossToolchainVariables
        ConfigurePkg \
            --prefix="${PREFIX}" \
            --enable-static \
            --disable-shared \
            --disable-man

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        mkdir -p "${PREFIX}/lib/ccache"
        cd "${PREFIX}/lib/ccache" || exit 1
        FILE="../../bin/ccache"
        for N in c++ cpp g++ gcc
        do
            if [ -e "${FILE}" ]
            then
                ln -sf "${FILE}" "${N}"
                ln -sf "${FILE}" "${N}-${GCC_VER}"
                ln -sf "${FILE}" "${N}-${GCC_EXTRA_VER}"
                ln -sf "${FILE}" "${N}-extra"
                ln -sf "${FILE}" "${TARGET}-${N}"
                ln -sf "${FILE}" "${TARGET}-${N}-${GCC_VER}"
                ln -sf "${FILE}" "${TARGET}-${N}-${GCC_EXTRA_VER}"
                ln -sf "${FILE}" "${TARGET}-${N}-extra"
            fi
        done

        mkdir -p "${PREFIX}/etc"
        FILE="${PREFIX}/etc/ccache.conf"
        cat > "${FILE}" << EOF
# ccache system config
# This file is controlled by mxe, user config is in:
# ${CCACHE_DIR}/ccache.conf

base_dir = ${MAIN_DIR}
cache_dir = ${CCACHE_DIR}
compiler_check = %compiler% -v

EOF

        mkdir -p "${CCACHE_DIR}"
        FILE="${CCACHE_DIR}/ccache.conf"
        [ -e "${FILE}" ] || cat > "${FILE}" << EOF
# ccache user config
# https://ccache.samba.org/manual/latest.html#_configuration_settings

max_size = 20.0G

EOF

    fi
)

