#!/bin/sh

### System info ###
SYSTEM="AstraLinux-1.2_static"
ARCH=x86_64
TARGET=${ARCH}-cross-linux-gnu
DEFAULT_LIB_TYPE=static


### Build tools ###
# GCC_VER=4.3.2
GCC_VER=4.3.6
# GCC_EXTRA_VER=4.9.3
GCC_EXTRA_VER=6.2.0
# BINUTILS_VER=2.18
BINUTILS_VER=2.26

MAKE_VER=3.81
TEXINFO_VER=4.13
LIBTOOL_VER=1.5.26
MAKEDEPEND_VER=1.0.5

CMAKE_VER=2.8.1
CMAKE_SUBVER=2.8
PKGCONFIG_VER=0.22


### System kernel ###
LINUX_VER=2.6.34.7
LINUX_SUBVER=2.6


### Basic libraries ###
GLIBC_VER=2.7
PTHREADS_VER=0.3


### Graphic subsystem related libraries ###
LIBPCIACCESS_VER=0.12.0

X11PROTO_CORE_VER=7.0.17
X11PROTO_INPUT_VER=2.0
X11PROTO_KB_VER=1.0.4
X11PROTO_XEXT_VER=7.1.1
X11PROTO_FIXES_VER=4.1.1
X11PROTO_DAMAGE_VER=1.2.0
X11PROTO_GL_VER=1.4.11
X11PROTO_DRI2_VER=2.3
X11PROTO_XF86BIGFONT_VER=1.2.0
X11PROTO_XF86VIDMODE_VER=2.3
X11PROTO_RENDER_VER=0.11
X11PROTO_RANDR_VER=1.3.1

LIBXAU_VER=1.0.6
LIBXDMCP_VER=1.0.3
LIBXCB_VER=1.6
XCB_PROTO_VER=${LIBXCB_VER}

XTRANS_VER=1.2.5
LIBX11_VER=1.3.3
LIBXEXT_VER=1.1.2
LIBXFIXES_VER=4.0.5
LIBXDAMAGE_VER=1.1.3
LIBXXF86VM_VER=1.1.0
LIBXRENDER_VER=0.9.6
LIBXRANDR_VER=1.3.0
LIBXI_VER=1.3
LIBXT_VER=1.0.7
LIBSM_VER=1.0.3
LIBICE_VER=1.0.4

# LIBDRM_VER=2.4.60
# MESA_VER=10.5.4
LIBDRM_VER=2.4.22
MESA_VER=7.8.2
GLU_VER=


### System libraries ###
# LIBXML2_VER=2.7.6
LIBXML2_VER=2.9.4
# LIBXSLT_VER=1.1.24
LIBXSLT_VER=1.1.29
# EXPAT_VER=2.2.0
EXPAT_VER=2.0.1

ZLIB_VER=1.2.8
BZIP2_VER=1.0.6

LIBPNG_VER=1.2.56
JPEG_VER=9b
JPEG_TURBO_VER=1.5.0
TIFF_VER=4.0.6
GIFLIB_VER=5.1.4
YASM_VER=1.3.0

OPENSSL_VER=1.0.2h
OPENSSL_SUBVER=${OPENSSL_VER}
LIBGPG_ERROR_VER=1.23
LIBGCRYPT_VER=1.7.1

HARFBUZZ_VER=
FREETYPE_VER=2.6.3
FONTCONFIG_VER=2.12.0


### Developer libraries ###
PROTOBUF_VER=2.6.1
BOOST_VER=1.61.0

FREEGLUT_VER=3.0.0
SDL2_VER=2.0.4

QT4_VER=4.8.7
QT4_SUBVER=4.8
QT5_VER=5.4.2
QT5_SUBVER=5.4
QWT_VER=6.1.3

PROJ_VER=4.9.2
GDAL_VER=1.11.1
OPENSCENEGRAPH_VER=3.4.0

EXIV2_VER=0.25
OPENCV_VER=2.4.13

X264_VER=20160706-2245
FFMPEG_VER=3.1.1


### Extra libraries ###
VLC_VER=2.2.1
# VLC_VER=2.1.6
# VLC_VER=1.1.6

LIBFCGI_VER=2.4.0

