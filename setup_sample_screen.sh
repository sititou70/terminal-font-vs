#!/bin/bash
set -eu

. setting.sh

# main
tmux new -d -s $SAMPLE_SCREEN_SESSION_NAME

#pane 1
tmux send-key -t $SAMPLE_SCREEN_SESSION_NAME.1 "vim sample.txt" C-m "sws,s,s,s,sw"

#pane 2
tmux split-window -v -t $SAMPLE_SCREEN_SESSION_NAME
tmux send-key -t $SAMPLE_SCREEN_SESSION_NAME.2 "ll" C-m
tmux resize-pane -t $SAMPLE_SCREEN_SESSION_NAME.2 -D 5

#pane 3
tmux split-window -h -t $SAMPLE_SCREEN_SESSION_NAME
tmux send-key -t $SAMPLE_SCREEN_SESSION_NAME.3 "htop" C-m
