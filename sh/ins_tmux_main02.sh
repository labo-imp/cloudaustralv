#!/bin/bash
tmux new-session -d -s sinstalling '/home/$USER/cloud-install/sh/ins_main02.sh; exec $SHELL'
