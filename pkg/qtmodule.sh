#!/bin/sh

[ -z "${PKG}" ] && exit 1

(
    PKG_VERSION=${QT5_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=${PKG}-opensource-src-${PKG_VERSION}
    PKG_FILE=${PKG}-opensource-src-${PKG_VERSION}.tar.xz
    PKG_URL="http://download.qt.io/archive/qt/${QT5_SUBVER}/${QT5_VER}/submodules/${PKG_FILE}"
    PKG_DEPS="qtbase"

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        PrepareBuild

        SetBuildFlags "${GCC_EXTRA_VER}"
        UpdateGCCSymlinks "${GCC_EXTRA_VER}"
        SetCrossToolchainVariables "${GCC_EXTRA_VER}"
        SetCrossToolchainPath
        ConfigureQmakeProject \
            "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/${PKG}.pro"

        BuildPkg -j ${JOBS} -i -k
        InstallPkg install -i -k

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        rm -rf "${SYSROOT}/qt5/lib"/*.la
    fi
)

