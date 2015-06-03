#!/bin/sh

[ -z "${X11PROTO_XF86BIGFONT_VER}" ] && exit 1

(
    PKG=x11proto-xf86bigfont
    PKG_VERSION=${X11PROTO_XF86BIGFONT_VER}
    PKG_SUBDIR_ORIG=xf86bigfontproto-${PKG_VERSION}
    PKG_DEPS="gcc pkg-config-settings"

    . "${PKG_DIR}/x11proto-module.sh"
)

