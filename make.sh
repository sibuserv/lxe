#!/bin/bash
#
# This file is part of LXE project. See LICENSE file for licensing information.

export MAIN_DIR="$(dirname $(realpath -s ${0}))"

# Setup

cd "${MAIN_DIR}"
. "${MAIN_DIR}/settings.sh"
. "${MAIN_DIR}/tools/define-paths.sh"
. "${MAIN_DIR}/tools/configure-options.sh"
. "${MAIN_DIR}/tools/util.sh"

# Help, version, clean up an full clean up
if [ "${1}" = "help" ]
then
    echo \
"Usage: make [option] [package 1] [package 2] [package 3] ...

Options:
    all             build all available packages
    list            display the list of available packages
    download        download sources without build of packages
    clean           clean up (delete dist/ subdirectory with all files)
    distclean       full clean up (delete dist/ and src/ subdirectories with all files)
    version         display LXE version and exit
    help            display this help and exit

Examples:
    make
    make all
    make qt5 qwt
    make qtbase qtserialport qtscript
    make gdal freeglut
    make \"download\"
    make \"download all\"
    make \"download ffmpeg sdl2\"
    make clean
    make distclean

Settings:
    Edit file settings.sh or add file settings.sh.<any-suffix>

Configs:
    Some samples are available in subdirectory etc/
"
    exit 0
elif [ "${1}" = "version" ]
then
    if [ -d "${MAIN_DIR}/.git" ] && which git &>/dev/null
    then
        git describe --tags
    elif [ -e "${MAIN_DIR}/changelog" ]
    then
        grep '^--- ' "${MAIN_DIR}/changelog" | head -n1 | \
            sed -ne "s|^--- \(.*\) ---$|\1|p"
    else
        echo "Version can not be determined!"
        echo "Clone original git repo or copy original"\
             "tarball with sources of this project."
        exit 1
    fi
    exit 0
elif [ "${1}" = "list" ]
then
    grep 'PKG=' "${MAIN_DIR}/pkg"/*.sh | sed -ne "s|.*pkg/\(.*\)\.sh:.*|\1|p"
    exit 0
elif [ "${1}" = "clean" ] && [ -z "${2}" ]
then
    read -p "Do you wish to delete all files from \"dist\" subdirectory? [y/N] " REPLY
    case "${REPLY}" in
    "y" | "Y" | "yes" | "Yes")
        echo "rm -rf \"${MAIN_DIR}/dist\""
        rm -rf "${MAIN_DIR}/dist"
    ;;
    *)
        echo "Aborted."
    ;;
    esac
    exit 0
elif [ "${1}" = "distclean" ] && [ -z "${2}" ]
then
    "${MAIN_DIR}/make.sh" clean
    read -p "Do you wish to delete all files from \"src\" subdirectory? [y/N] " REPLY
    case "${REPLY}" in
    "y" | "Y" | "yes" | "Yes")
        echo "rm -rf \"${MAIN_DIR}/src\""
        rm -rf "${MAIN_DIR}/src"
    ;;
    *)
        echo "Aborted."
    ;;
    esac
    exit 0
elif [ "${1}" = "download" ]
then
    export DOWNLOAD_ONLY="true"
fi

# Make packages

BuildPackages()
{
    if [ ! -z "${1}" ]
    then
        if [ "${1}" = "all" ]
        then
            BuildAllPackages
        elif [ "${1}" = "download" ]
        then
            if [ "${2}" = "all" ]
            then
                BuildAllPackages
            elif [ ! -z "${2}" ]
            then
                BuildPackagesFromOptions ${@}
            else
                BuildPackagesFromSettings
            fi
        else
            BuildPackagesFromOptions ${@}
        fi
    elif [ ! -z "${LOCAL_PKG_LIST}" ]
    then
        BuildPackagesFromSettings
    fi
}

BuildAllPackages()
{
    for ARG in $(${0} list)
    do
        IsOption "${ARG}" && continue || true
        IsIgnoredPackage "${ARG}" && continue || true
        if [ -e "${MAIN_DIR}/pkg/${ARG}.sh" ]
        then
            . "${MAIN_DIR}/pkg/${ARG}.sh" || exit 1
        else
            echo "Package ${ARG} does not exist!"
            exit 1
        fi
    done
}

BuildPackagesFromOptions()
{
    for ARG in ${@}
    do
        IsOption "${ARG}" && continue || true
        if [ -e "${MAIN_DIR}/pkg/${ARG}.sh" ]
        then
            . "${MAIN_DIR}/pkg/${ARG}.sh" || exit 1
        else
            echo "Package ${ARG} does not exist!"
            exit 1
        fi
    done
}

BuildPackagesFromSettings()
{
    for ARG in ${LOCAL_PKG_LIST}
    do
        if [ -e "${MAIN_DIR}/pkg/${ARG}.sh" ]
        then
            . "${MAIN_DIR}/pkg/${ARG}.sh" || exit 1
        else
            echo "Package ${ARG} does not exist!"
            exit 1
        fi
    done
}

for CONFIG in ${CONFIGS}
do
    if [ -e "${MAIN_DIR}/etc/${CONFIG}.sh" ]
    then
        . "${MAIN_DIR}/etc/${CONFIG}.sh"
    else
        echo "Config ${CONFIG} does not exist!"
        exit 1
    fi

    DefinePaths
    PrepareDirs
    PrepareConfigureOpts
    BuildPackages ${@}
done

