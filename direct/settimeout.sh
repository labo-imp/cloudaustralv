#!/bin/bash

diro=$(pwd)
cd /home/$USER/log
/home/$USER/install/settimeout "$@"
echo "manual" > manual.txt

cd  $diro