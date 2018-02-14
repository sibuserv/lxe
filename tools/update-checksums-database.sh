#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

# Help
if [ "${1}" = "--help" ] || [ "${1}" = "-h" ] || [ -z "${1}" ]
then
    echo \
"Usage: ./update-checksums-database.sh [filename 1] [filename 2] [filename 3] ...

Examples:
    ./update-checksums-database.sh qtlocation-everywhere-src-5.10.1.tar.xz
    ./update-checksums-database.sh qtquickcontrols2-everywhere-src-5.10.1.tar.xz
"
    exit 0
fi

# Script body
[ -z "${MAIN_DIR}" ] && export MAIN_DIR="$(realpath -s $(dirname ${0})/..)"

cd "${MAIN_DIR}/src" || exit 1

for FILE_NAME in ${@}
do
    sha256sum "${FILE_NAME}"
    [ $? -eq 0 ] || continue

    sha256sum "${FILE_NAME}" >> "${MAIN_DIR}/etc/_checksums.database.txt"
    sort -fuV -k2 "${MAIN_DIR}/etc/_checksums.database.txt" > \
                  "${MAIN_DIR}/etc/_checksums.database.txt__"
    mv -f "${MAIN_DIR}/etc/_checksums.database.txt__" \
          "${MAIN_DIR}/etc/_checksums.database.txt"
done

