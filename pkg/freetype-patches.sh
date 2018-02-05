#!/bin/sh
#
# This file is part of LXE project. See LICENSE file for licensing information.

(
    FILE="${PKG_SRC_DIR}/${PKG_SUBDIR}/builds/unix/install.mk"

    FROM_STR="	-\$(DELETE) \$(DESTDIR)\$(includedir)/freetype2/freetype"
    TO_STR="	# -\$(DELETE) \$(DESTDIR)\$(includedir)/freetype2/freetype"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"

    FROM_STR="	-\$(DELDIR) \$(DESTDIR)\$(includedir)/freetype2/freetype"
    TO_STR="	# -\$(DELDIR) \$(DESTDIR)\$(includedir)/freetype2/freetype"
    sed -i "${FILE}" -e "s!${FROM_STR}!${TO_STR}!g"
)

