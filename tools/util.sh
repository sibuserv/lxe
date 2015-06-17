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

    ln -snf "lib" "${SYSROOT}/lib64"
    ln -snf "lib" "${SYSROOT}/usr/lib64"
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

SetCrossToolchainVariables()
{
    export CROSS_COMPILE=${TARGET}-
    export cc=${CROSS_COMPILE}gcc
    export CC=${CROSS_COMPILE}gcc
    export cxx=${CROSS_COMPILE}g++
    export CXX=${CROSS_COMPILE}g++
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

SetBuildFlags()
{
    export CFLAGS="-s -Os -fPIC -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fdata-sections -ffunction-sections"
    export LDFLAGS="-Wl,--strip-all -Wl,--as-needed -Wl,-z,relro -Wl,--gc-sections"
    export CXXFLAGS="${CFLAGS} -std=c++11"
}

SetGlibcBuildFlags()
{
    export CFLAGS="-s -O2 -fPIC -fno-stack-protector -U_FORTIFY_SOURCE"
    export LDFLAGS="-Wl,--strip-all"
    export CXXFLAGS="${CFLAGS}"
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
    # TODO: rewrite without using of dpkg (for non Debian-based systems)
    dpkg --compare-versions "${1}" ge "${2}" && \
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

PrepareConfigureOpts()
{
    LXE_CONFIGURE_OPTS="--build=${BUILD} --target=${TARGET} --host=${TARGET}"
}

PrepareLibTypeOpts()
{
    local LIB_TYPE="${DEFAULT_LIB_TYPE}"
    [ ! -z "${1}" ] && LIB_TYPE="${1}"
    if [ "${LIB_TYPE}" = "static" ]
    then
        LIB_TYPE_OPTS="--enable-static --disable-shared"
    elif [ "${LIB_TYPE}" = "both" ]
    then
        LIB_TYPE_OPTS="--enable-static --enable-shared"
    else
        LIB_TYPE_OPTS="--enable-shared --disable-static"
    fi
}

PrepareBuild()
{
    mkdir -p "${BUILD_DIR}/${PKG_SUBDIR}"
    cd "${LOG_DIR}/${PKG_SUBDIR}"
    rm -f configure.log make.log make-install.log

    PrepareLibTypeOpts
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
}

ConfigurePkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    if [ -z "${PKG_SUBDIR_ORIG}" ]
    then 
        "${PKG_SRC_DIR}/${PKG_SUBDIR}/configure" ${@} &> "${LOG_FILE}"
    else
        "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/configure" ${@} &> "${LOG_FILE}"
    fi
    CheckFail "${LOG_FILE}"
}

ConfigurePkgInBuildDir()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    ./configure ${@} &> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureQmakeProject()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    local PATH="${PREFIX}/qt5/bin:${PATH}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    "${SYSROOT}/qt5/bin/qmake" ${@} &> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureCmakeProject()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    local CMAKE_TOOLCHAIN_FILE="${SYSROOT}/usr/share/cmake/${SYSTEM}.config.cmake"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    cmake -DCMAKE_TOOLCHAIN_FILE="${CMAKE_TOOLCHAIN_FILE}" ${@} &> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

BuildPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make ${@} &> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

InstallPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make-install.log"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make ${@} &> "${LOG_FILE}"
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
    rm -rf "${SYSROOT}/lib"/*.la
    rm -rf "${SYSROOT}/usr/lib"/*.la
}

