#!/bin/sh

[ -z "${OPENSCENEGRAPH_VER}" ] && exit 1

(
    PKG=openscenegraph
    PKG_VERSION=${OPENSCENEGRAPH_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=OpenSceneGraph-${PKG_VERSION}
    PKG_FILE=OpenSceneGraph-${PKG_VERSION}.zip
    PKG_URL="http://trac.openscenegraph.org/downloads/developer_releases/${PKG_FILE}"
    PKG_DEPS="gcc pkg-config-settings zlib libpng jpeg tiff giflib freetype gdal cmake-settings"
    [ ! -z "${GCC_EXTRA_VER}" ] && PKG_DEPS="${PKG_DEPS} gcc-extra"

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
        CXXFLAGS="${CXXFLAGS} -fpermissive"
        ConfigureCmakeProject \
            -DCMAKE_BUILD_TYPE=Release \
            -DPKG_CONFIG_EXECUTABLE="${PREFIX}/bin/${TARGET}-pkg-config" \
            -DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
            -DCMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}" \
            -DCMAKE_EXE_LINKER_FLAGS="${LDFLAGS}" \
            -DBUILD_SHARED_LIBS=OFF \
            -DDYNAMIC_OPENTHREADS=OFF \
            -DDYNAMIC_OPENSCENEGRAPH=OFF \
            -DBUILD_OSG_APPLICATIONS=OFF \
            -DOSG_USE_QT=OFF \
            -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
            "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}"
#             -DCMAKE_INSTALL_PREFIX="${SYSROOT}/usr" \
#             -DCMAKE_PREFIX_PATH="${SYSROOT}/usr" \
#             -DCMAKE_MODULE_PATH="${SYSROOT}/usr" \

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir

        UpdateGCCSymlinks
    fi
)

