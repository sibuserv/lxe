#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=pkg-config
    PKG_VERSION=${PKGCONFIG_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=pkg-config-${PKG_VERSION}
    PKG_FILE=pkg-config-${PKG_VERSION}.tar.gz
    PKG_URL="https://pkgconfig.freedesktop.org/releases/${PKG_FILE}"
    PKG_DEPS="libtool"

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
            --infodir="${PREFIX}/share/info" \
            --mandir="${PREFIX}/share/man" \
            --enable-static \
            --disable-shared

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        cd "${PREFIX}/bin"
        mv "pkg-config" "pkg-config-bin"
        cat > "${TARGET}-pkg-config" << EOF
#!/bin/sh
PKG_CONFIG_SYSROOT_DIR="/" \\
PKG_CONFIG_PATH="${SYSROOT}/usr/lib/pkgconfig" \\
PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig" \\
exec "${PREFIX}/bin/pkg-config-bin" --static "\${@}"
EOF
        chmod uog+x "${TARGET}-pkg-config"
        ln -sf "${TARGET}-pkg-config" "pkg-config"
    fi
)

