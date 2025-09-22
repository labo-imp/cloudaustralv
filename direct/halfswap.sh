#!/bin/bash

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

divisor=2

if [[ $MIHOST == "desktop-jr" ]]; then
    divisor=6
fi

myUsed=$( df -BG /dev/root  | tail -1 | awk '{print $4}' | sed 's/.$//' )
echo $myUsed
ramtotal=$(awk '{ printf "%.0f", $2/1024/1024 ; exit}' /proc/meminfo)
echo $ramtotal
available=$(( ($myUsed/ $divisor) < $ramtotal ? ($myUsed/ $divisor) : $ramtotal ))

echo $available

sudo  fallocate -l "$available"G  /swap
sudo  chmod 600 /swap
sudo  mkswap /swap
sudo  swapon /swap
