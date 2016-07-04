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

        mkdir -p "${SYSROOT}/usr/share/cmake"
        for GCC_CURRENT_VER in ${GCC_VER} ${GCC_EXTRA_VER}
        do
            SetBuildFlags "${GCC_CURRENT_VER}"

            CMAKE_TOOLCHAIN_FILE="${SYSROOT}/usr/share/cmake/${SYSTEM}.gcc-${GCC_CURRENT_VER}.conf.cmake"

            mkdir -p "${SYSROOT}/usr/share/cmake"
            cat > "${CMAKE_TOOLCHAIN_FILE}" << EOF
set(CMAKE_SYSTEM_NAME Linux)
set(BUILD_SHARED_LIBS OFF)
set(LIBTYPE STATIC)
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_PREFIX_PATH "${SYSROOT}")
set(CMAKE_FIND_ROOT_PATH "${SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_C_COMPILER "${PREFIX}/bin/${TARGET}-gcc-${GCC_CURRENT_VER}")
set(CMAKE_CXX_COMPILER "${PREFIX}/bin/${TARGET}-g++-${GCC_CURRENT_VER}")
set(CMAKE_C_FLAGS "${CFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${CXXFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${LDFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_INSTALL_PREFIX "${SYSROOT}/usr" CACHE PATH "Installation Prefix")
set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")
set(CMAKE_CROSS_COMPILING ON) # Workaround for http://www.cmake.org/Bug/view.php?id=14075
set(PKG_CONFIG_EXECUTABLE ${PREFIX}/bin/${TARGET}-pkg-config)
EOF

            mkdir -p "${PREFIX}/bin"
            cat > "${PREFIX}/bin/${TARGET}-gcc-${GCC_CURRENT_VER}-cmake" << EOF
#!/bin/sh

cmake -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE}" \${@}
EOF
            chmod uog+x "${PREFIX}/bin"/${TARGET}-*cmake

            unset CMAKE_TOOLCHAIN_FILE
        done

        date -R > "${INST_DIR}/${PKG}"
        echo "[config]   ${CONFIG}"
        echo "[no-build] ${PKG}"
    fi
)

