#!/bin/bash

export MAIN_DIR="$(dirname $(realpath -s ${0}))"

# Setup

cd "${MAIN_DIR}"
. "${MAIN_DIR}/settings.sh"
. "${MAIN_DIR}/tools/define-paths.sh"
. "${MAIN_DIR}/tools/util.sh"

# Help, version, clean up an full clean up
if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]
then
    echo \
"Usage: ./make.sh [option] [package 1] [package 2] [package 3] ...

Options:
    clean           clean up (delete dist/ subdirectory with all files)
    distclean       full clean up (delete dist/ and src/ subdirectories with all files)
    -V, --version   display LXE version and exit
    -h, --help      display this help and exit

Examples:
    ./make.sh
    ./make.sh qt5
    ./make.sh qtbase qtserialport qtscript
    ./make.sh gdal freeglut
    ./make.sh clean
    ./make.sh distclean

Settings:
    Edit file settings.sh

Configs:
    Some samples are available in subdirectory etc/
"
    exit 0
elif [ "${1}" = "-V" ] || [ "${1}" = "--version" ]
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
elif [ "${1}" = "clean" ] && [ -z "${2}" ]
then
    set -x
    rm -rf "${MAIN_DIR}/dist"
    exit 0
elif [ "${1}" = "distclean" ] && [ -z "${2}" ]
then
    set -x
    rm -rf "${MAIN_DIR}/dist"
    rm -rf "${MAIN_DIR}/src"
    exit 0
fi

# Make packages

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

    if [ ! -z "${1}" ]
    then
        for ARG in ${@}
        do
            if [ -e "${MAIN_DIR}/pkg/${ARG}.sh" ]
            then
                . "${MAIN_DIR}/pkg/${ARG}.sh" || exit 1
            else
                echo "Package ${ARG} does not exist!"
                exit 1
            fi
        done
    elif [ ! -z "${LOCAL_PKG_LIST}" ]
    then
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
    fi
done

