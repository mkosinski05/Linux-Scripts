#!/bin/bash

if [ $# -gt 0 ];then
    exec "$@"
else
    tmux new -s "RV2M_Yocto" && \
    tmux set -g status off && tmux attach

    cd ~/rzv2m

fi
