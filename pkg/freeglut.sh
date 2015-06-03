#!/bin/sh

[ -z "${FREEGLUT_VER}" ] && exit 1

(
    PKG=freeglut
    PKG_VERSION=${FREEGLUT_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG}-${PKG_VERSION}.tar.gz
    PKG_URL="http://sourceforge.net/projects/${PKG}/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc mesa libxi"
    [ ! -z "${GLU_VER}" ] && PKG_DEPS="${PKG_DEPS} glu"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "static"
        ConfigurePkg \
            --prefix="${SYSROOT}/usr" \
            --with-sysroot="${SYSROOT}" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --enable-replace-glut \
            --disable-debug \
            --with-gnu-ld

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

