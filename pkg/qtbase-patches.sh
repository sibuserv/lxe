#!/bin/sh

(
    cd "${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}"

    PATCH_FILE="${PKG_DIR}/${PKG}-${PKG_VERSION}.patch"
    if [ -e "${PATCH_FILE}" ]
    then
        LOG_FILE="${LOG_DIR}/${PKG_SUBDIR}/patch.log"
        patch -p1 -i "${PATCH_FILE}" &> "${LOG_FILE}"
    fi

    mkdir -p "mkspecs/linux-g++-${SYSTEM}"
    cp -af "mkspecs/linux-g++"/* "mkspecs/linux-g++-${SYSTEM}/"

    SetCrossToolchainVariables "${GCC_EXTRA_VER}"
    FILE="mkspecs/linux-g++-${SYSTEM}/qmake.conf"
    cat > "${FILE}" << EOF
MAKEFILE_GENERATOR      = UNIX
CONFIG                 += incremental
QMAKE_INCREMENTAL_STYLE = sublib

include(../common/linux.conf)
include(../common/gcc-base-unix.conf)
include(../common/g++-unix.conf)

# sysroot
QMAKE_INCDIR            = \$\$[QT_SYSROOT]/usr/include
QMAKE_LIBDIR            = \$\$[QT_SYSROOT]/usr/lib

# modifications to g++-unix.conf
QMAKE_CC                = ${CC}
QMAKE_CXX               = ${CXX}
QMAKE_LINK              = \$\${QMAKE_CXX}
QMAKE_LINK_SHLIB        = \$\${QMAKE_CXX}

# modifications to linux.conf
QMAKE_AR                = ${AR} cqs
QMAKE_OBJCOPY           = ${OBJCOPY}
QMAKE_NM                = ${NM} -P
QMAKE_STRIP             = ${STRIP}

# build flags
QMAKE_CFLAGS           += -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fPIC
QMAKE_CFLAGS           += -fdata-sections -ffunction-sections
QMAKE_CXXFLAGS         +=  \$\${QMAKE_CFLAGS} -std=c++11
QMAKE_LFLAGS           += -Wl,-z,relro -Wl,--as-needed
QMAKE_LFLAGS           += -static-libgcc -static-libstdc++

QMAKE_CFLAGS_RELEASE   += -Os
QMAKE_CXXFLAGS_RELEASE += -Os
QMAKE_LFLAGS_RELEASE   += -Wl,-s -Wl,--gc-sections

QMAKE_CFLAGS_ISYSTEM    =

load(qt_config)

EOF

    if ! IsPkgVersionGreaterOrEqualTo "5.5.0"
    then
        # Workaround for fixing programs linking when Qt is built with static freetype:
        if [ -e "${SYSROOT}/usr/lib/libfreetype.a" ]
        then
            PATH="${PREFIX}/bin:${ORIG_PATH}"
            FILE="${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/mkspecs/features/qpa/basicunixfontdatabase.prf"
            FROM_STR="^.*LIBS += .*$"
            TO_STR="    LIBS += $(${TARGET}-pkg-config --static --libs freetype2)"
            sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"
        fi

        # Workaround for fixing programs linking when Qt is built with static libfontconfig:
        if [ -e "${SYSROOT}/usr/lib/libfontconfig.a" ]; then
            PATH="${PREFIX}/bin:${ORIG_PATH}"
            FILE="${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/mkspecs/features/qpa/genericunixfontdatabase.prf"
            FROM_STR="^.*LIBS += .*$"
            TO_STR="    LIBS += $(${TARGET}-pkg-config --static --libs fontconfig)"
            sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"
        fi
    fi
)

