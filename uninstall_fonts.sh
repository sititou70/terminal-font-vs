#!/bin/bash
set -eu

. setting.sh

# main
rm -rf "$FONTS_SYM_LINK/$(basename $FONTS_DIR)"
fc-cache -fv $FONTS_SYM_LINK
