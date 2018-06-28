#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    PKG=minizip
    PKG_VERSION=${MINIZIP_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=zlib-${ZLIB_VER}
    PKG_FILE=${PKG_SUBDIR_ORIG}.tar.gz
    # https://www.zlib.net/
    # http://www.winimage.com/zLibDll/minizip.html
    PKG_URL="https://sourceforge.net/projects/libpng/files/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    PKG_DEPS="gcc zlib"

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

        cd "${PKG_SRC_DIR}"
        cp -aT "${PKG_SUBDIR_ORIG}/contrib/minizip" "${PKG_SUBDIR}"
        rm -rf "${PKG_SUBDIR_ORIG}"
        unset PKG_SUBDIR_ORIG

        cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
        export LIBTOOL="/usr/bin/libtool"
        autoreconf -vfi &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        ConfigureAutotoolsProject

        BuildPkg -j ${JOBS} minizip miniunzip LIBTOOL="${LIBTOOL}"
        InstallPkg install LIBTOOL="${LIBTOOL}"

        CleanPkgBuildDir
        CleanPkgSrcDir

        if IsStaticPackage
        then
            rm -f "${SYSROOT}/usr/lib/libminizip.so"*
        else
            rm -f "${SYSROOT}/usr/lib/libminizip.a"
        fi
    fi
)

