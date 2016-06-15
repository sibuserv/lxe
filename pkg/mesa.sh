#!/bin/sh

[ -z "${MESA_VER}" ] && exit 1

(
    PKG=mesa
    PKG_VERSION=${MESA_VER}
    PKG_SUBDIR=${PKG}-${PKG_VERSION}
    if IsPkgVersionGreaterOrEqualTo "10.5.0"
    then
        PKG_FILE=${PKG}-${PKG_VERSION}.tar.xz
        PKG_URL="ftp://freedesktop.org/pub/${PKG}/${PKG_VERSION}/${PKG_FILE}"
    else
        PKG_SUBDIR_ORIG=Mesa-${PKG_VERSION}
        PKG_FILE=MesaLib-${PKG_VERSION}.tar.bz2
        IsPkgVersionGreaterOrEqualTo "10.0" && \
            PKG_URL="ftp://freedesktop.org/pub/${PKG}/older-versions/${PKG_VERSION:0:2}.x/${PKG_VERSION}/${PKG_FILE}" || \
            PKG_URL="ftp://freedesktop.org/pub/${PKG}/older-versions/${PKG_VERSION:0:1}.x/${PKG_VERSION}/${PKG_FILE}"
    fi
    PKG_DEPS="gcc pkg-config-settings expat makedepend x11proto-gl x11proto-dri2 libx11 libxext libxfixes libxdamage libxxf86vm libxt libdrm"
    # libx11-xcb-dev, libxcb-dri2-0-dev, libxcb-xfixes0-dev
    # python, python-libxml2 (for some versions of mesa)

    if ! IsPkgInstalled
    then
        CheckDependencies

        GetSources
        UnpackSources
        CopySrcAndPrepareBuild

        SetBuildFlags
        SetCrossToolchainPath
        SetCrossToolchainVariables
        PrepareLibTypeOpts "shared"
        cd "${BUILD_DIR}/${PKG_SUBDIR}"
        autoreconf -vfi &>> "${LOG_DIR}/${PKG_SUBDIR}/configure.log"
        ConfigurePkgInBuildDir \
            --prefix="${SYSROOT}/usr" \
            ${LXE_CONFIGURE_OPTS} \
            ${LIB_TYPE_OPTS} \
            --enable-glx-tls \
            --enable-xcb \
            --disable-egl \
            --disable-glut \
            --disable-glw \
            --disable-dri3 \
            --with-driver=xlib \
            --with-state-trackers=glx \
            --without-gallium-drivers
#             --enable-gles1 \
#             --enable-gles2 \
#             --with-gnu-ld \

        BuildPkg -j ${JOBS}
        InstallPkg install

        CleanPkgBuildDir
        CleanPkgSrcDir
    fi
)

