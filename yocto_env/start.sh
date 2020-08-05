#!/bin/bash

if [ $# -gt 0 ];then
  exec "$@"
else
  tmux new -s "RG2E_Yocto" && \
  tmux set -g status off && tmux attach
fi
