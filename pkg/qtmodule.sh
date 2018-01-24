#!/bin/sh

[ -z "${PKG}" ] && exit 1

(
    PKG_VERSION=${QT5_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    if IsPkgVersionGreaterOrEqualTo "5.10.0"
    then
        PKG_SUBDIR_ORIG=${PKG}-everywhere-src-${PKG_VERSION}
        PKG_FILE=${PKG}-everywhere-src-${PKG_VERSION}.tar.xz
    else
        PKG_SUBDIR_ORIG=${PKG}-opensource-src-${PKG_VERSION}
        PKG_FILE=${PKG}-opensource-src-${PKG_VERSION}.tar.xz
    fi
    PKG_URL="http://download.qt.io/archive/qt/${QT5_SUBVER}/${QT5_VER}/submodules/${PKG_FILE}"

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

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks

        find "${SYSROOT}/qt5/lib" -type f -name '*.la' -exec rm -f {} \;
    fi
)

