#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=hunspell
    PKG_VERSION=${HUNSPELL_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_FILE=${PKG_SUBDIR}.tar.gz
    if IsPkgVersionGreaterOrEqualTo "1.3.4"
    then
        PKG_URL="https://github.com/hunspell/hunspell/archive/v${PKG_VERSION}.tar.gz"
    else
        PKG_URL="https://sourceforge.net/projects/hunspell/files/Hunspell/${PKG_VERSION}/${PKG_FILE}"
    fi
    PKG_DEPS="gcc"

    CheckPkgVersion
    CheckSourcesAndDependencies

    if IsBuildRequired
    then
        PrintSystemInfo
        BeginOfPkgBuild
        UnpackSources
        PrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        if IsPkgVersionGreaterOrEqualTo "1.3.4"
        then
            cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
            autoreconf -vfi &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        fi
        ConfigureAutotoolsProject \
            --with-warnings \
            --without-ui \
            --with-readline

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

