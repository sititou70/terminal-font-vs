#!/bin/bash
set -eu

export CWD=$(pwd)

# fonts
export FONTS_DIR="$CWD/TEMP_fonts"
export FONTS_SYM_LINK="$HOME/.local/share/fonts"
export FONT_SIZE=12

# terminator
export TERMINATOR_BASE_CONFIG="$HOME/.config/terminator/config"
export TERMINATOR_TEMP_CONFIG="$CWD/TEMP_terminator_config"
export SAMPLE_SCREEN_SESSION_NAME="terminal-font-vs"

# screenshot images
export SCREENSHOT_DIR="$CWD/TEMP_screenshot"