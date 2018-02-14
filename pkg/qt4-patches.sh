#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
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

load(qt_config)

EOF
)

