#!/bin/sh

[ -z "${CMAKE_VER}" ] && exit 1

(
    PKG=cmake-settings
    PKG_VERSION=${CMAKE_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    PKG_SUBDIR_ORIG=cmake-${PKG_VERSION}
    PKG_FILE=cmake-${PKG_VERSION}.tar.gz
    PKG_URL="http://www.cmake.org/files/v${CMAKE_SUBVER}/${PKG_FILE}"
    PKG_DEPS=

    if ! IsPkgInstalled
    then
        CheckDependencies

        SetCrossToolchainVariables
        mkdir -p "${SYSROOT}/usr/share/cmake"

        cat > "${SYSROOT}/usr/share/cmake/${SYSTEM}.config.cmake" << EOF
set(CMAKE_SYSTEM_NAME Linux)
set(BUILD_SHARED_LIBS OFF)
set(LIBTYPE STATIC)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_FIND_ROOT_PATH ${SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_C_COMPILER ${PREFIX}/bin/${CC})
set(CMAKE_CXX_COMPILER ${PREFIX}/bin/${CXX})
set(CMAKE_INSTALL_PREFIX ${SYSROOT}/usr CACHE PATH "Installation Prefix")
set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")
set(CMAKE_CROSS_COMPILING ON) # Workaround for http://www.cmake.org/Bug/view.php?id=14075
set(PKG_CONFIG_EXECUTABLE ${PREFIX}/bin/${TARGET}-pkg-config)
EOF

        date -R > "${INST_DIR}/${PKG}"
        echo "[no-build] ${PKG}"
    fi
)

