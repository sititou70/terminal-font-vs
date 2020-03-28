#!/bin/bash
set -eu

. setting.sh

# main

[ ! -e $FONTS_DIR ] && mkdir $FONTS_DIR

## powerline fonts
if [ ! -e "$FONTS_DIR/3270Medium.ttf" ]; then
  git clone https://github.com/powerline/fonts.git
  mv fonts/**/*.ttf $FONTS_DIR
  rm -rf fonts
fi

## install fonts
[ ! -e "$FONTS_SYM_LINK/$(basename $FONTS_DIR)" ] && ln -s $FONTS_DIR $FONTS_SYM_LINK
fc-cache -fv $FONTS_SYM_LINK
