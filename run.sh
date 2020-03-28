#!/bin/bash
set -eu

. setting.sh

# setup
./install_fonts.sh
./setup_sample_screen.sh

# screenshot
npx ts-node screenshot.ts

# cleanup
tmux kill-session -t $SAMPLE_SCREEN_SESSION_NAME
./uninstall_fonts.sh
