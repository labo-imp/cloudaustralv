#!/bin/bash
sleep 30
usuarioid=$(id -u $USER)
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$usuarioid/bus
export DBUS_SESSION_BUS_ADDRESS

mkdir -p /home/$USER/log
cd  /home/$USER/log
/home/$USER/install/memcpu  $usuarioid
