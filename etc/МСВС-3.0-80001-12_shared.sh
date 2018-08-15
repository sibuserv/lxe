#!/bin/sh

# This system is not supported now!

### System info ###
SYSTEM="МСВС-3.0-80001-12_shared"
ARCH=i486
TARGET=${ARCH}-cross-linux-gnu
DEFAULT_LIB_TYPE=shared


### Build tools ###
# GCC_VER=4.1.3
GCC_VER=4.1.2
# GCC_EXTRA_VER=4.9.3
GCC_EXTRA_VER=6.4.0
# BINUTILS_VER=2.18
BINUTILS_VER=2.27

MAKE_VER=3.81
TEXINFO_VER=4.13
LIBTOOL_VER=1.5.26
MAKEDEPEND_VER=1.0.5

CMAKE_VER=2.8.1
CMAKE_SUBVER=2.8
PKGCONFIG_VER=0.22


### System kernel ###
LINUX_VER=2.4.37.9
LINUX_SUBVER=2.4


### Basic libraries ###
GLIBC_VER=2.3.6
PTHREADS_VER=0.1


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
X11PROTO_SCRNSAVER_VER=1.2.0

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
LIBXSS_VER=1.2.0

LIBDRM_VER=2.4.22
MESA_VER=7.8.2
GLU_VER=


### System libraries ###
UDEV_VER=
LIBUSB_VER=
PCIUTILS_VER=3.1.7
USBUTILS_VER=
SYSFSUTILS_VER=

LIBXML2_VER=2.7.6
LIBXSLT_VER=1.1.24
EXPAT_VER=2.0.1

# ZLIB_VER=1.2.3.3
ZLIB_VER=1.2.3
BZIP2_VER=1.0.5

LIBPNG_VER=1.2.38
LIBPNG_SUBVER=12
JPEG_VER=6b
JPEG_TURBO_VER=1.4.1
USE_JPEG_TURBO=
TIFF_VER=3.8.2
GIFLIB_VER=4.1.6
YASM_VER=1.3.0

LIBGPG_ERROR_VER=1.4
LIBGCRYPT_VER=1.4.4
OPENSSL_VER=0.9.8n
OPENSSL_SUBVER=0.9.x

HARFBUZZ_VER=
FREETYPE_VER=2.4.2
FONTCONFIG_VER=2.8.0

SQLITE_VER=3.6.16
SQLITE_FOSSIL_VER=ff691a6b

ASPELL_VER=0.60.6
HUNSPELL_VER=1.2.6
LIBIDN_VER=1.8
ATTR_VER=2.4.44
CURL_VER=7.18.2
ICU_VER=4.0.1


### Developer libraries ###
PROTOBUF_VER=3.6.1
BOOST_VER=1.65.0

FREEGLUT_VER=2.6.0
# FREEGLUT_VER=3.0.0
SDL2_VER=2.0.4

QT4_VER=4.6.3
QT4_SUBVER=4.6
QT5_VER=5.4.2
QT5_SUBVER=5.4

QCA_VER=2.1.0
QWT_VER=6.1.3
QTKEYCHAIN_VER=

PROJ_VER=4.9.3
GDAL_VER=2.2.3
OPENSCENEGRAPH_VER=3.4.1
OSGEARTH_VER=2.8

EXIV2_VER=0.25
OPENCV_VER=3.4.0

X264_VER=20161130-2245
FFMPEG_VER=4.0.1


### Extra libraries ###
LIBFCGI_VER=2.4.0
MINIZIP_VER=1.1

TIDY_HTML5_VER=5.4.0
LIBOTR_VER=4.0.0
MXML_VER=2.11
TINYXML2_VER=6.0.0

LIBSIGNAL_PROTOCOL_C_VER=2.3.2

QTWEBKIT_VER=ea590d7
QTWEBKIT_GIT_VER=ea590d74eae21dd70b189e0b8ba4bfb6a9bddb94

