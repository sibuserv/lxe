#!/bin/sh

### System info ###
SYSTEM="AstraLinux-1.5_shared"
ARCH=x86_64
TARGET=${ARCH}-cross-linux-gnu
DEFAULT_LIB_TYPE=shared


### Build tools ###
# GCC_VER=4.7.2
GCC_VER=4.7.4
# GCC_EXTRA_VER=4.9.3
GCC_EXTRA_VER=6.4.0
# BINUTILS_VER=2.22
BINUTILS_VER=2.27

MAKE_VER=3.81
TEXINFO_VER=4.13
LIBTOOL_VER=2.4.2
MAKEDEPEND_VER=1.0.5

CMAKE_VER=2.8.12.2
CMAKE_SUBVER=2.8
PKGCONFIG_VER=0.26


### System kernel ###
LINUX_VER=4.2.8
LINUX_SUBVER=4.x


### Basic libraries ###
GLIBC_VER=2.15
PTHREADS_VER=0.3


### Graphic subsystem related libraries ###
LIBPCIACCESS_VER=0.13.1

X11PROTO_CORE_VER=7.0.28
X11PROTO_INPUT_VER=2.3.1
X11PROTO_KB_VER=1.0.6
X11PROTO_XEXT_VER=7.3.0
X11PROTO_FIXES_VER=5.0
X11PROTO_DAMAGE_VER=1.2.1
X11PROTO_GL_VER=1.4.17
X11PROTO_DRI2_VER=2.8
X11PROTO_XF86BIGFONT_VER=1.2.0
X11PROTO_XF86VIDMODE_VER=2.3.1
X11PROTO_RENDER_VER=0.11.1
X11PROTO_RANDR_VER=1.5.0
X11PROTO_SCRNSAVER_VER=1.2.2

LIBXAU_VER=1.0.7
LIBXDMCP_VER=1.1.1
LIBXCB_VER=1.11.1
XCB_PROTO_VER=1.11

XTRANS_VER=1.3.5
LIBX11_VER=1.6.3
LIBXEXT_VER=1.3.3
LIBXFIXES_VER=5.0.1
LIBXDAMAGE_VER=1.1.3
LIBXXF86VM_VER=1.1.2
LIBXRENDER_VER=0.9.7
LIBXRANDR_VER=1.5.0
LIBXI_VER=1.7.4
LIBXT_VER=1.1.3
LIBSM_VER=1.2.1
LIBICE_VER=1.0.9
LIBXSS_VER=1.2.2

LIBDRM_VER=2.4.65
MESA_VER=10.5.9
GLU_VER=9.0.0


### System libraries ###
UDEV_VER=175
LIBUSB_VER=1.0.11
PCIUTILS_VER=3.1.9
USBUTILS_VER=005
SYSFSUTILS_VER=2.1.0

LIBXML2_VER=2.8.0
LIBXSLT_VER=1.1.26
EXPAT_VER=2.1.0

ZLIB_VER=1.2.7
BZIP2_VER=1.0.6

LIBPNG_VER=1.2.49
LIBPNG_SUBVER=12
JPEG_VER=8d
JPEG_TURBO_VER=1.4.1
USE_JPEG_TURBO=
TIFF_VER=4.0.3
GIFLIB_VER=4.1.6
YASM_VER=1.2.0

LIBGPG_ERROR_VER=1.10
LIBGCRYPT_VER=1.5.0
OPENSSL_VER=1.0.1e
OPENSSL_SUBVER=1.0.1

HARFBUZZ_VER=0.9.35
FREETYPE_VER=2.5.5
FONTCONFIG_VER=2.11.1

SQLITE_VER=3.7.13
SQLITE_FOSSIL_VER=f5b5a13f

ASPELL_VER=0.60.6.1
LIBIDN_VER=1.25
# ATTR_VER=2.4.46
ATTR_VER=2.4.44
CURL_VER=7.26.0


### Developer libraries ###
PROTOBUF_VER=3.5.1
BOOST_VER=1.65.0

# FREEGLUT_VER=2.6.0
FREEGLUT_VER=3.0.0
SDL2_VER=2.0.8

QT4_VER=4.8.7
QT4_SUBVER=4.8
# QT5_VER=5.3.0
# QT5_SUBVER=5.3
QT5_VER=5.11.1
QT5_SUBVER=5.11

QCA_VER=2.1.3
QWT_VER=6.1.3

PROJ_VER=5.1.0
GDAL_VER=2.2.3
OPENSCENEGRAPH_VER=3.6.1
OSGEARTH_VER=2.9

EXIV2_VER=0.25
OPENCV_VER=3.4.0

X264_VER=20161130-2245
FFMPEG_VER=3.4.2


### Extra libraries ###
VLC_VER=2.1.4

LIBFCGI_VER=2.4.0

TIDY_HTML5_VER=5.4.0
LIBOTR_VER=4.1.1
MXML_VER=2.11
TINYXML2_VER=6.0.0

LIBSIGNAL_PROTOCOL_C_VER=2.3.1
