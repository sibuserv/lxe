#!/bin/sh

### System info ###
SYSTEM="AstraLinux-1.3_static"
ARCH=x86_64
TARGET=${ARCH}-cross-linux-gnu
DEFAULT_LIB_TYPE=static


### Build tools ###
# GCC_VER=4.7.1
GCC_VER=4.7.4
# GCC_EXTRA_VER=4.9.3
GCC_EXTRA_VER=6.3.0
# BINUTILS_VER=2.22
BINUTILS_VER=2.27

MAKE_VER=3.81
TEXINFO_VER=4.13
LIBTOOL_VER=2.4.2
MAKEDEPEND_VER=1.0.5

CMAKE_VER=2.8.8
CMAKE_SUBVER=2.8
PKGCONFIG_VER=0.26


### System kernel ###
LINUX_VER=3.2.27
LINUX_SUBVER=3.x


### Basic libraries ###
GLIBC_VER=2.13
PTHREADS_VER=0.3


### Graphic subsystem related libraries ###
LIBPCIACCESS_VER=0.13.1

X11PROTO_CORE_VER=7.0.23
X11PROTO_INPUT_VER=2.2
X11PROTO_KB_VER=1.0.6
X11PROTO_XEXT_VER=7.2.1
X11PROTO_FIXES_VER=5.0
X11PROTO_DAMAGE_VER=1.2.1
X11PROTO_GL_VER=1.4.15
X11PROTO_DRI2_VER=2.6
X11PROTO_XF86BIGFONT_VER=1.2.0
X11PROTO_XF86VIDMODE_VER=2.3.1
X11PROTO_RENDER_VER=0.11.1
X11PROTO_RANDR_VER=1.3.2

LIBXAU_VER=1.0.7
LIBXDMCP_VER=1.1.1
LIBXCB_VER=1.8.1
XCB_PROTO_VER=1.7.1

XTRANS_VER=1.2.7
LIBX11_VER=1.5.0
LIBXEXT_VER=1.3.1
LIBXFIXES_VER=5.0
LIBXDAMAGE_VER=1.1.3
LIBXXF86VM_VER=1.1.2
LIBXRENDER_VER=0.9.7
LIBXRANDR_VER=1.3.2
LIBXI_VER=1.6.1
LIBXT_VER=1.1.3
LIBSM_VER=1.2.1
LIBICE_VER=1.0.8

LIBDRM_VER=2.4.33
MESA_VER=8.0.3
GLU_VER=


### System libraries ###
LIBXML2_VER=2.9.4
LIBXSLT_VER=1.1.29
EXPAT_VER=2.2.0

ZLIB_VER=1.2.8
BZIP2_VER=1.0.6

LIBPNG_VER=1.2.57
JPEG_VER=9b
JPEG_TURBO_VER=1.5.1
TIFF_VER=4.0.7
GIFLIB_VER=5.1.4
YASM_VER=1.3.0

OPENSSL_VER=1.0.2k
OPENSSL_SUBVER=${OPENSSL_VER}
LIBGPG_ERROR_VER=1.25
LIBGCRYPT_VER=1.7.3

HARFBUZZ_VER=
FREETYPE_VER=2.7
FONTCONFIG_VER=2.12.1


### Developer libraries ###
PROTOBUF_VER=3.1.0
BOOST_VER=1.62.0

FREEGLUT_VER=3.0.0
SDL2_VER=2.0.5

QT4_VER=4.8.7
QT4_SUBVER=4.8
QT5_VER=5.7.0
QT5_SUBVER=5.7
QWT_VER=6.1.3

PROJ_VER=4.9.3
GDAL_VER=1.11.1
OPENSCENEGRAPH_VER=3.4.0

EXIV2_VER=0.25
OPENCV_VER=2.4.13

X264_VER=20161130-2245
FFMPEG_VER=3.2.4


### Extra libraries ###
VLC_VER=2.0.3

LIBFCGI_VER=2.4.0

