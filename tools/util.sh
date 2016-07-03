#!/bin/bash

PrepareDirs()
{
    mkdir -p "${PREFIX}"
    mkdir -p "${SYSROOT}"
    mkdir -p "${SRC_DIR}"
    mkdir -p "${PKG_SRC_DIR}"
    mkdir -p "${BUILD_DIR}"
    mkdir -p "${LOG_DIR}"
    mkdir -p "${INST_DIR}"

    mkdir -p "${SYSROOT}/lib"
    mkdir -p "${SYSROOT}/usr/lib"

    if [ "${ARCH}" = x86_64 ]
    then
        ln -snf "lib" "${SYSROOT}/lib64"
        ln -snf "lib" "${SYSROOT}/usr/lib64"
    fi
}

SetCrossToolchainPath()
{
    export PATH="${PREFIX}/bin:${ORIG_PATH}"
}

SetSystemPath()
{
    export PATH="${ORIG_PATH}"
}

SetLibraryPath()
{
    export LIBRARY_PATH="${LIBRARY_PATH}:${SYSROOT}/lib"
    export LIBRARY_PATH="${LIBRARY_PATH}:${SYSROOT}/usr/lib"
}

UnsetLibraryPath()
{
    unset LIBRARY_PATH
}

UnsetMakeFlags()
{
    unset MAKEFLAGS
}

SetCrossToolchainVariables()
{
    [ ! -z "${1}" ] && \
        local GCC_SUFFIX=-${1} || \
        local GCC_SUFFIX=-${GCC_VER}

    export CROSS_COMPILE=${TARGET}-
    export cc=${CROSS_COMPILE}gcc${GCC_SUFFIX}
    export CC=${CROSS_COMPILE}gcc${GCC_SUFFIX}
    export cxx=${CROSS_COMPILE}g++${GCC_SUFFIX}
    export CXX=${CROSS_COMPILE}g++${GCC_SUFFIX}
    export AR=${CROSS_COMPILE}ar
    export AS=${CROSS_COMPILE}as
    export LD=${CROSS_COMPILE}ld
    export NM=${CROSS_COMPILE}nm
    export OBJCOPY=${CROSS_COMPILE}objcopy
    export OBJDUMP=${CROSS_COMPILE}objdump
    export RANLIB=${CROSS_COMPILE}ranlib
    export STRIP=${CROSS_COMPILE}strip

    export PKG_CONFIG_SYSROOT_DIR="/"
    export PKG_CONFIG_PATH="${SYSROOT}/usr/lib/pkgconfig"
    export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/pkgconfig"
}

UnsetCrossToolchainVariables()
{
    unset CROSS_COMPILE cc CC cpp CPP cxx CXX
    unset AR AS LD NM OBJCOPY OBJDUMP RANLIB STRIP
    unset PKG_CONFIG_SYSROOT_DIR PKG_CONFIG_PATH PKG_CONFIG_LIBDIR
}

UpdateGCCSymlinks()
{
    [ ! -z "${1}" ] && \
        local GCC_CURRENT_VER=${1} || \
        local GCC_CURRENT_VER=${GCC_VER}

    local FILE=""

    cd "${PREFIX}/bin"
    for N in c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-tool
    do
        FILE="${N}-${GCC_CURRENT_VER}"
        if [ -e "${FILE}" ]
        then
            ln -sf "${FILE}" "${N}"
            ln -sf "${FILE}" "${TARGET}-${N}"
            ln -sf "${FILE}" "${TARGET}-${N}-${GCC_CURRENT_VER}"
        fi
    done

    # Fix for old libGL (mesa) built without RPATH:
    cd "${SYSROOT}/usr/lib"
    for N in libgcc_s.so.1 libstdc++.so.6
    do
        FILE="${SYSROOT}/usr/lib/gcc/${TARGET}/${GCC_CURRENT_VER}/${N}"
        if [ -e "${FILE}" ]
        then
            ln -sf "${FILE}" "${N}"
        fi
    done
}

DeleteGCCSymlinks()
{
    cd "${PREFIX}/bin"
    rm -f c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-tool
}

SetBuildFlags()
{
    [ ! -z "${1}" ] && \
        local GCC_CURRENT_VER=${1} || \
        local GCC_CURRENT_VER=${GCC_VER}

    export CFLAGS="-s -Os -fPIC -fdata-sections -ffunction-sections -D_FORTIFY_SOURCE=2"
    IsVer1GreaterOrEqualToVer2 "${GCC_CURRENT_VER}" "4.9.0" && \
        export CFLAGS="${CFLAGS} -fstack-protector-strong"

    export CXXFLAGS="${CFLAGS}"
    if IsVer1GreaterOrEqualToVer2 "${GCC_CURRENT_VER}" "4.9.0"
    then
        IsVer1GreaterOrEqualToVer2 "${GCC_CURRENT_VER}" "6.1.0" && \
            export CXXFLAGS="${CXXFLAGS} -std=c++14" || \
            export CXXFLAGS="${CXXFLAGS} -std=c++11"
    fi

    export LDFLAGS="-Wl,--strip-all -Wl,--as-needed -Wl,-z,relro -Wl,--gc-sections"
    
    if [ "${GCC_CURRENT_VER}" != "${GCC_VER}" ]
    then
        export CFLAGS="${CFLAGS} -static-libgcc"
        export CXXFLAGS="${CXXFLAGS} -static-libgcc -static-libstdc++"
    fi
}

SetGlibcBuildFlags()
{
    export CFLAGS="-s -O2 -U_FORTIFY_SOURCE"
    IsVer1GreaterOrEqualToVer2 "${GCC_VER}" "4.9.0" && \
        export CFLAGS="${CFLAGS} -fno-stack-protector"

    if [[ "${ARCH}" == i*86 ]]
    then
        export CFLAGS="${CFLAGS} -m32 -march=${ARCH}"
    elif [ "${ARCH}" = x86_64 ]
    then
        export CFLAGS="${CFLAGS} -m64"
    fi

    export CXXFLAGS="${CFLAGS}"
    export LDFLAGS="-Wl,--strip-all"
}

SetGCCBuildFlags()
{
    export CFLAGS="-s -O2 -fPIC -fno-stack-protector -U_FORTIFY_SOURCE"
    export CXXFLAGS="${CFLAGS}"
    export LDFLAGS="-Wl,--strip-all"
}

CheckFail()
{
    if [ ! $? -eq 0 ]
    then
        tail -n 50 "${1}"
        exit 1
    fi
}

CheckDependencies()
{
    if [ ! -z "${PKG_DEPS}" ]
    then
        ( "${MAIN_DIR}/make.sh" ${PKG_DEPS} ) || exit 1
    fi
}

IsVer1GreaterOrEqualToVer2()
{
    [ "${1}" = "$(echo -e "${1}\n${2}" | sort -V | tail -n1)" ] && \
        return 0 || \
        return 1
}

IsPkgVersionGreaterOrEqualTo()
{
    IsVer1GreaterOrEqualToVer2 "${PKG_VERSION}" "${1}" && \
        return 0 || \
        return 1
}

IsPkgInstalled()
{
    [ -e "${INST_DIR}/${PKG}" ] && \
        return 0 || \
        return 1
}

BeginOfPkgBuild()
{
    echo "[config]   ${CONFIG}"
    echo "[build]    ${PKG}"
}

EndOfPkgBuild()
{
    date -R > "${INST_DIR}/${PKG}"
    echo "[done]     ${PKG}"
}

GetSources()
{
    BeginOfPkgBuild

    local WGET="wget -v -c --no-config --no-check-certificate --max-redirect=50"
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/tarball-download.log"
    local TARBALL_SIZE="${LOG_DIR}/${PKG_SUBDIR}/tarball-size.info"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${SRC_DIR}"
    if [ ! -e "${PKG_FILE}" ]
    then
        local SIZE=$(curl -I "${PKG_URL}" 2>&1 | sed -ne "s|^Content-Length: \(.*\)$|\1|p")
        echo "${SIZE}" > "${TARBALL_SIZE}"
        ${WGET} -o "${LOG_FILE}" -O "${PKG_FILE}" "${PKG_URL}"
        CheckFail "${LOG_FILE}"
    elif [ -e "${TARBALL_SIZE}" ]
    then
        local SIZE=$(cat "${TARBALL_SIZE}")
        local FILE_SIZE=$(curl -I "file:${SRC_DIR}/${PKG_FILE}" 2>&1 | sed -ne "s|^Content-Length: \(.*\)$|\1|p")
        if [ "${FILE_SIZE}" != "${SIZE}" ]
        then
            ${WGET} -o "${LOG_FILE}" -O "${PKG_FILE}" "${PKG_URL}"
            CheckFail "${LOG_FILE}"
        fi
    fi
}

UnpackSources()
{
    set -e
    cd "${PKG_SRC_DIR}"
    [ ! -z "${PKG_SUBDIR_ORIG}" ] && \
            local SUBDIR="${PKG_SUBDIR_ORIG}" || \
            local SUBDIR="${PKG_SUBDIR}"

    if [ ! -d "${SUBDIR}" ]
    then
        cp -a "${SRC_DIR}/${PKG_FILE}" .
        if [[ "${PKG_FILE}" == *.zip ]]
        then
            unzip -q "${PKG_FILE}"
        else
            tar xf "${PKG_FILE}"
        fi
        rm "${PKG_FILE}"
        if [ -e "${MAIN_DIR}/pkg/${PKG}-patches.sh" ]
        then
            . "${MAIN_DIR}/pkg/${PKG}-patches.sh"
        elif [ -h "${MAIN_DIR}/pkg/${PKG}-patches.sh" ]
        then
            . "${MAIN_DIR}/pkg/${PKG}-patches.sh"
        fi
    fi
    set +e
}

PrepareBuild()
{
    mkdir -p "${BUILD_DIR}/${PKG_SUBDIR}"
    cd "${LOG_DIR}/${PKG_SUBDIR}"
    rm -f configure.log make.log make-install.log

    PrepareLibTypeOpts
    UnsetMakeFlags
}

CopySrcAndPrepareBuild()
{
    if [ -z "${PKG_SUBDIR_ORIG}" ]
    then 
        cp -afT "${PKG_SRC_DIR}/${PKG_SUBDIR}" "${BUILD_DIR}/${PKG_SUBDIR}"
    else
        cp -afT "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}" "${BUILD_DIR}/${PKG_SUBDIR}"
    fi
    cd "${LOG_DIR}/${PKG_SUBDIR}"
    rm -f configure.log make.log make-install.log

    PrepareLibTypeOpts
    UnsetMakeFlags
}

ConfigurePkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    if [ -z "${PKG_SUBDIR_ORIG}" ]
    then 
        "${PKG_SRC_DIR}/${PKG_SUBDIR}/configure" ${@} &>> "${LOG_FILE}"
    else
        "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/configure" ${@} &>> "${LOG_FILE}"
    fi
    CheckFail "${LOG_FILE}"
}

ConfigurePkgInBuildDir()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    ./configure ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureQmakeProject()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    local PATH="${PREFIX}/qt5/bin:${PATH}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    "${SYSROOT}/qt5/bin/qmake" ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureCmakeProject()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    local CMAKE_TOOLCHAIN_FILE="${SYSROOT}/usr/share/cmake/${SYSTEM}.config.cmake"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    cmake -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE}" ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

BuildPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

InstallPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make-install.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"

    DeleteExtraFiles
    EndOfPkgBuild
}

CleanPkgSrcDir()
{
    if [ "${CLEAN_SRC_DIR}" = "true" ]
    then
        [ -z "${PKG_SUBDIR_ORIG}" ] && \
            rm -rf "${PKG_SRC_DIR}/${PKG_SUBDIR}" || \
            rm -rf "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}"
    fi
}

CleanPkgBuildDir()
{
    if [ "${CLEAN_BUILD_DIR}" = "true" ]
    then
        rm -rf "${BUILD_DIR}/${PKG_SUBDIR}"
    fi
}

DeleteExtraFiles()
{
    find "${SYSROOT}/lib" "${SYSROOT}/usr/lib" -type f -name '*.la' -exec rm -f {} \;
}

