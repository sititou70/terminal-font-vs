#!/bin/bash
set -eu

. setting.sh

# main

[ ! -e $FONTS_DIR ] && mkdir $FONTS_DIR

## powerline fonts
#if [ ! -e "$FONTS_DIR/3270Medium.ttf" ]; then
#  git clone https://github.com/powerline/fonts.git
#  mv fonts/**/*.ttf $FONTS_DIR
#  rm -rf fonts
#fi

## awsome-jp-coding-fonts
if [ ! -e "$FONTS_DIR/Cica.ttc" ]; then
  wget https://github.com/tsunesan3/awsome-jp-coding-fonts/releases/download/v1.0.0/awsome-jp-coding-fonts-v1.0.0.zip
  mkdir tmp
  cd tmp
  unzip ../awsome-jp-coding-fonts-v1.0.0.zip
  cd ..
  mv tmp/*.ttc $FONTS_DIR
  mv tmp/*.ttf $FONTS_DIR
  rm -rf tmp awsome-jp-coding-fonts-v1.0.0.zip
fi

## HackGen
if [ ! -e "$FONTS_DIR/HackGen-Regular.ttf" ]; then
  wget https://github.com/yuru7/HackGen/releases/download/v1.4.1/HackGen_v1.4.1.zip
  unzip HackGen_v1.4.1.zip
  mv HackGen_v1.4.1/*.ttf $FONTS_DIR
  rm -rf HackGen_v1.4.1.zip HackGen_v1.4.1
fi

## install fonts
[ ! -e "$FONTS_SYM_LINK/$(basename $FONTS_DIR)" ] && ln -s $FONTS_DIR $FONTS_SYM_LINK
fc-cache -fv $FONTS_SYM_LINK
