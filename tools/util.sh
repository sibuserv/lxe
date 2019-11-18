#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

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

AddCcachePath()
{
    [ "${LXE_USE_CCACHE}" != true ] && return 0
    [ "${PKG}" = ccache ] && return 0

    export PATH="${PREFIX}/lib/ccache:${PATH}"
}

SetCrossToolchainPath()
{
    export PATH="${PREFIX}/bin:${ORIG_PATH}"
    AddCcachePath
}

SetSystemPath()
{
    export PATH="${ORIG_PATH}"
    AddCcachePath
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

PermanentGCCSymlinks()
{
    if [ -z "${1}" ] || [ -z "${1}" ]
    then
        echo "Function PermanentGCCSymlinks() requires two arguments."
        exit 1
    fi

    local GCC_CURRENT_VER=${1}
    local GCC_SUFFIX=${2}
    local FILE=""

    cd "${PREFIX}/bin"
    for N in c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-tool
    do
        FILE="${N}-${GCC_CURRENT_VER}"
        if [ -e "${FILE}" ]
        then
            ln -sf "${FILE}" "${N}-${GCC_SUFFIX}"
            ln -sf "${FILE}" "${TARGET}-${N}-${GCC_SUFFIX}"
        fi
    done
}

DeleteGCCSymlinks()
{
    cd "${PREFIX}/bin"
    rm -f c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-tool
}

UpdateCmakeSymlink()
{
    [ ! -z "${1}" ] && \
        local GCC_CURRENT_VER=${1} || \
        local GCC_CURRENT_VER=${GCC_VER}

    ln -sf "${PREFIX}/bin/${TARGET}-gcc-${GCC_CURRENT_VER}-cmake" \
           "${PREFIX}/bin/${TARGET}-cmake"
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

IsStaticPackage()
{
    [ "${DEFAULT_LIB_TYPE}" = "static" ] && return 0 || true

    for STATIC_PKG in ${STATIC_PKG_LIST}
    do
        [ "${STATIC_PKG}" = "${PKG}" ] && return 0 || true
    done
    return 1
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

PrintSystemInfo()
{
    echo "[config]   ${CONFIG}"
}

BeginOfPkgBuild()
{
    echo "[build]    ${PKG}"
}

BeginDownload()
{
    echo "[download] ${PKG_FILE}"
}

EndOfPkgBuild()
{
    date -R > "${INST_DIR}/${PKG}"
    echo "[done]     ${PKG}"
}

CheckPkgVersion()
{
    if [ -z "${PKG_VERSION}" ]
    then
        echo "Version of package \"${PKG}\" is empty!"
        echo "Check config for \"${SYSTEM}\"..."
        exit 1
    fi
}

CheckPkgUrl()
{
    if [ ! -z "${PKG_URL_2}" ]
    then
        local HTTP_REPLY=$(curl -L -I "${PKG_URL}" 2>/dev/null | grep 'HTTP/')
        if [ $(echo "${HTTP_REPLY}" | grep '404' | wc -l) != "0" ]
        then
            PKG_URL="${PKG_URL_2}"
        elif ! curl -L -I "${PKG_URL}" &> /dev/null
        then
            PKG_URL="${PKG_URL_2}"
        fi
        unset PKG_URL_2
    fi
}

FileSize()
{
    du ${@} | sed -ne "s;^\(.*\)\t.*$;\1;p"
}

IsOption()
{
    local OPTIONS_LIST="all clean distclean download help list version"
    for OPT in ${OPTIONS_LIST}
    do
        [ "${1}" = "${OPT}" ] && return 0
    done
    return 1
}

IsDownloadOnly()
{
    [ "${DOWNLOAD_ONLY}" = "true" ] && \
        return 0 || \
        return 1
}

IsPkgInstalled()
{
    [ -e "${INST_DIR}/${PKG}" ] && \
        return 0 || \
        return 1
}

IsDownloadRequired()
{
    if IsBuildRequired || IsDownloadOnly
    then
        cd "${SRC_DIR}"
        if [ -e "${PKG_FILE}" ]
        then
            if [ $(FileSize "${PKG_FILE}") = "0" ]
            then
                return 0
            else
                VerifyChecksum
                return 1
            fi
        else
            return 0
        fi
    fi

    return 1
}

IsBuildRequired()
{
    IsDownloadOnly && return 1 || true
    IsPkgInstalled && return 1 || true

    [ "${DO_NOT_BUILD}" = "true" ] && \
        return 1 || \
        return 0
}

IsIgnoredPackage()
{
    local IGNORED_PKGS_LIST="jpeg libjpeg-turbo cmake pkg-config qt4 qtwebkit"

    for IGNORED_PKG in ${IGNORED_PKGS_LIST}
    do
        if [ "${IGNORED_PKG}" = "${1}" ]
        then
            return 0
        fi
    done
    return 1
}

IsTarballCheckRequired()
{
    local MUTABLE_TARBALLS_PKG_LIST="sqlite"

    for PKG_WITH_MUTABLE_TARBALL in ${MUTABLE_TARBALLS_PKG_LIST}
    do
        if [ "${PKG_WITH_MUTABLE_TARBALL}" = "${PKG}" ]
        then
            echo "[checksum] skip check of ${PKG_FILE}"
            return 1
        fi
    done
    return 0
}

CheckSourcesAndDependencies()
{
    if IsBuildRequired || IsDownloadRequired
    then
        CheckDependencies

        IsDownloadRequired && GetSources
    fi
}

GetSources()
{
    local WGET="wget -v -c --no-config --no-check-certificate --max-redirect=50"
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/tarball-download.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${SRC_DIR}"
    if [ -e "${PKG_FILE}" ]
    then
        if [ $(FileSize "${PKG_FILE}") = "0" ]
        then
            rm "${PKG_FILE}"
        fi
    fi
    if [ ! -e "${PKG_FILE}" ]
    then
        BeginDownload
        CheckPkgUrl
        ${WGET} -o "${LOG_FILE}" -O "${PKG_FILE}" "${PKG_URL}"
        CheckFail "${LOG_FILE}"
    fi
    if [ $(FileSize "${PKG_FILE}") = "0" ]
    then
        echo "Error! The size of downloaded tarball is equal to zero!"
        echo "Check your Internet connection and accessibility of URL:"
        echo "${PKG_URL}"
        echo "Removing ${PKG_FILE}..."
        rm "${PKG_FILE}"
        exit 1
    fi
    VerifyChecksum
}

VerifyChecksum()
{
    local CHECKSUMS_DATABASE_FILE="${MAIN_DIR}/etc/_checksums.database.txt"
    if [ $(grep "${PKG_FILE}" "${CHECKSUMS_DATABASE_FILE}" | wc -l) != "1" ]
    then
        echo "[checksum] ${PKG_FILE}"
        echo "Error! Checksum for file \"${PKG_FILE}\" is not found in"
        echo "${CHECKSUMS_DATABASE_FILE}"
        echo "You may add this file into database using special script:"
        echo "./tools/update-checksums-database.sh \"${PKG_FILE}\""
        exit 1
    fi
    local PKG_CHECKSUM=$(cat "${CHECKSUMS_DATABASE_FILE}" | sed -ne "s|^\(.*\)  ${PKG_FILE}$|\1|p")
    local TARBALL_CHECKSUM=$(openssl dgst -sha256 "${PKG_FILE}" 2>/dev/null | sed -n 's,^.*\([0-9a-f]\{64\}\)$,\1,p')
    if [ "${TARBALL_CHECKSUM}" != "${PKG_CHECKSUM}" ] && IsTarballCheckRequired
    then
        echo "[checksum] ${PKG_FILE}"
        echo "Error! Checksum mismatch:"
        echo "TARBALL_CHECKSUM = ${TARBALL_CHECKSUM}"
        echo "PKG_CHECKSUM     = ${PKG_CHECKSUM}"
        echo "Try to remove tarball to force build system to download it again:"
        echo "rm \"${SRC_DIR}/${PKG_FILE}\""
        exit 1
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

        local PATCH_FILE="${PKG_DIR}/${PKG}-${PKG_VERSION}.patch"
        if [ -e "${PATCH_FILE}" ] || [ -h "${PATCH_FILE}" ]
        then
            local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
            mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
            cd "${PKG_SRC_DIR}/${SUBDIR}"
            patch -p1 -i "${PATCH_FILE}" &> "${LOG_FILE}"
        fi
        local PATCH_SCRIPT="${MAIN_DIR}/pkg/${PKG}-patches.sh"
        if [ -e "${PATCH_SCRIPT}" ] || [ -h "${PATCH_SCRIPT}" ]
        then
            . "${PATCH_SCRIPT}"
        fi
    fi
    set +e
}

PrepareBuild()
{
    mkdir -p "${BUILD_DIR}/${PKG_SUBDIR}"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
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
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${LOG_DIR}/${PKG_SUBDIR}"
    rm -f configure.log make.log make-install.log

    PrepareLibTypeOpts
    UnsetMakeFlags
}

GenerateConfigureScript()
{
    if [ ! -e "${PKG_SRC_DIR}/${PKG_SUBDIR}/configure" ]
    then
        if [ ! -z "${PKG_SUBDIR_ORIG}" ]
        then 
            cd "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}"
        else
            cd "${PKG_SRC_DIR}/${PKG_SUBDIR}"
        fi
        autoreconf -vfi &> "${LOG_DIR}/${PKG_SUBDIR}/autoreconf.log"
    fi
}

GenerateConfigureScriptInBuildDir()
{
    if [ ! -e "${BUILD_DIR}/${PKG_SUBDIR}/configure" ]
    then
        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        autoreconf -vfi &> "${LOG_DIR}/${PKG_SUBDIR}/autoreconf.log"
    fi
}

ConfigurePkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
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
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    ./configure ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureAutotoolsProject()
{
    ConfigurePkg \
        --prefix="${SYSROOT}/usr" \
        ${LXE_CONFIGURE_OPTS} \
        ${LIB_TYPE_OPTS} \
        ${@}
}

ConfigureAutotoolsProjectInBuildDir()
{
    ConfigurePkgInBuildDir \
        --prefix="${SYSROOT}/usr" \
        ${LXE_CONFIGURE_OPTS} \
        ${LIB_TYPE_OPTS} \
        ${@}
}

ConfigureQmakeProject()
{
    local PATH="${PREFIX}/qt5/bin:${PATH}"
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    "${SYSROOT}/qt5/bin/qmake" ${@} &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

ConfigureCmakeProject()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/configure.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    if [ -z "${PKG_SUBDIR_ORIG}" ]
    then
        "${PREFIX}/bin/${TARGET}-cmake" "${PKG_SRC_DIR}/${PKG_SUBDIR}" "${@}" &>> "${LOG_FILE}"
    else
        "${PREFIX}/bin/${TARGET}-cmake" "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}" "${@}" &>> "${LOG_FILE}"
    fi
    CheckFail "${LOG_FILE}"
}

BuildGlibc()
{
    # This is an ugly hack for fixing build of glibc library ignoring one
    # unpredictable build error which looks like:
    # <some-path>/build/glibc-<library-version>/shlib.lds:135: syntax error
    # collect2: error: ld returned 1 exit status
    # make[2]: *** [<some-path>/build/glibc-<library-version>/libc.so] Error 1
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make "${@}" &>> "${LOG_FILE}"
    if [ ! $? -eq 0 ]
    then
        if [ $(grep '/shlib.lds:.*: syntax error' "${LOG_FILE}" | wc -l) != 0 ]
        then
            echo &>> "${LOG_FILE}"
            echo "!!!!! This unpredictable linker error has happened again..." &>> "${LOG_FILE}"
            echo "!!!!! Let's try to finish the build!" &>> "${LOG_FILE}"
            echo &>> "${LOG_FILE}"
            sleep 5

            export LANGUAGE=""
            export LC_ALL="C"
            unset cxx CXX
            ConfigurePkg \
                ${LXE_CONFIGURE_OPTS} \
                ${GLIBC_CONFIGURE_OPTS}

            make "${@}" &>> "${LOG_FILE}"
            CheckFail "${LOG_FILE}"
        else
            tail -n 50 "${LOG_FILE}"
            exit 1
        fi
    fi
}

BuildPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make "${@}" &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"
}

InstallPkg()
{
    local LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/make-install.log"
    mkdir -p "${LOG_DIR}/${PKG_SUBDIR}"
    cd "${BUILD_DIR}/${PKG_SUBDIR}"
    make "${@}" &>> "${LOG_FILE}"
    CheckFail "${LOG_FILE}"

    DeleteExtraFiles
    EndOfPkgBuild
}

ProcessStandardAutotoolsProject()
{
    PrintSystemInfo
    BeginOfPkgBuild
    UnpackSources
    PrepareBuild

    SetBuildFlags "${USE_GCC_EXTRA}"
    UpdateGCCSymlinks "${USE_GCC_EXTRA}"
    SetCrossToolchainVariables "${USE_GCC_EXTRA}"
    SetCrossToolchainPath

    GenerateConfigureScript
    ConfigureAutotoolsProject ${@}

    BuildPkg -j ${JOBS}
    InstallPkg install

    CleanPkgBuildDir
    CleanPkgSrcDir

    UpdateGCCSymlinks
}

ProcessStandardAutotoolsProjectInBuildDir()
{
    PrintSystemInfo
    BeginOfPkgBuild
    UnpackSources
    CopySrcAndPrepareBuild

    SetBuildFlags "${USE_GCC_EXTRA}"
    UpdateGCCSymlinks "${USE_GCC_EXTRA}"
    SetCrossToolchainVariables "${USE_GCC_EXTRA}"
    SetCrossToolchainPath

    GenerateConfigureScriptInBuildDir
    ConfigureAutotoolsProjectInBuildDir ${@}

    BuildPkg -j ${JOBS}
    InstallPkg install

    CleanPkgBuildDir
    CleanPkgSrcDir

    UpdateGCCSymlinks
}

CleanPkgSrcDir()
{
    [ -z "${PKG_SUBDIR_ORIG}" ] && \
        rm -rf "${PKG_SRC_DIR}/${PKG_SUBDIR}" || \
        rm -rf "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}"
}

CleanPkgBuildDir()
{
    rm -rf "${BUILD_DIR}/${PKG_SUBDIR}"
}

DeleteExtraFiles()
{
    find "${SYSROOT}/lib" "${SYSROOT}/usr/lib" -type f -name '*.la' -exec rm -f {} \;
}

