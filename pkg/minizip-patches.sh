#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    FILE="${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/contrib/minizip/Makefile.am"
    cat > "${FILE}" << EOF
lib_LTLIBRARIES = libminizip.la

if COND_DEMOS
bin_PROGRAMS = miniunzip minizip
endif

zlib_top_srcdir = \$(top_srcdir)/../..
zlib_top_builddir = \$(top_builddir)/../..

AM_CPPFLAGS = -I\$(zlib_top_srcdir)
AM_LDFLAGS = -L\$(zlib_top_builddir)

if WIN32
iowin32_src = iowin32.c
iowin32_h = iowin32.h
endif

libminizip_la_SOURCES = \
    ioapi.c \
    mztools.c \
    unzip.c \
    zip.c \
    \${iowin32_src}

libminizip_la_LDFLAGS = \$(AM_LDFLAGS) -version-info 1:0:0 -lz

minizip_includedir = \$(includedir)/minizip
minizip_include_HEADERS = \
    crypt.h \
    ioapi.h \
    mztools.h \
    unzip.h \
    zip.h \
    \${iowin32_h}

pkgconfigdir = \$(libdir)/pkgconfig
pkgconfig_DATA = minizip.pc

EXTRA_PROGRAMS = miniunzip minizip

miniunzip_SOURCES = miniunz.c
miniunzip_LDADD = libminizip.la

minizip_SOURCES = minizip.c
minizip_LDADD = libminizip.la -lz

EOF

    FILE="${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/contrib/minizip/configure.ac"
    cat > "${FILE}" << EOF
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_INIT([minizip], [1.2.8], [bugzilla.redhat.com])
AC_CONFIG_SRCDIR([minizip.c])
AM_INIT_AUTOMAKE([foreign])
LT_INIT

AC_MSG_CHECKING([whether to build example programs])
AC_ARG_ENABLE([demos], AC_HELP_STRING([--enable-demos], [build example programs]))
AM_CONDITIONAL([COND_DEMOS], [test "\${enable_demos}" = yes])
if test "\${enable_demos}" = yes
then
    AC_MSG_RESULT([yes])
else
    AC_MSG_RESULT([no])
fi

case "\${host}" in
    *-mingw* | mingw*)
        WIN32="yes"
        ;;
    *)
        ;;
esac
AM_CONDITIONAL([WIN32], [test "\${WIN32}" = "yes"])

AC_SUBST([HAVE_UNISTD_H], [0])
AC_CHECK_HEADER([unistd.h], [HAVE_UNISTD_H=1], [])
AC_CONFIG_FILES([Makefile minizip.pc])
AC_OUTPUT

EOF

    FILE="${PKG_SRC_DIR}/${PKG_SUBDIR_ORIG}/contrib/minizip/minizip.pc.in"
    cat > "${FILE}" << EOF
prefix=@prefix@
exec_prefix=@exec_prefix@
libdir=@libdir@
includedir=@includedir@/minizip

Name: minizip
Description: Minizip zip file manipulation library
Requires:
Version: @PACKAGE_VERSION@
Libs: -L\${libdir} -lminizip
Libs.private: -lz
Cflags: -I\${includedir}

EOF
)





