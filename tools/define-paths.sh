#!/bin/sh

ORIG_PATH="${PATH}"

DefinePaths()
{
    PREFIX="${MAIN_DIR}/dist/${SYSTEM}"
    SYSROOT="${PREFIX}/sysroot"
    PKG_DIR="${MAIN_DIR}/pkg"
    SRC_DIR="${MAIN_DIR}/src"
    PKG_SRC_DIR="${PREFIX}/src"
    BUILD_DIR="${PREFIX}/build"
    LOG_DIR="${PREFIX}/log"
    INST_DIR="${PREFIX}/installed"
}

