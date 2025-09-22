#!/bin/bash
sudo  mount -t cifs  //mlflow.rebelare.com/$smb_shared     /media/expshared  -o credentials=/home/$USER/install/expshared_cred.txt,uid=$(id -u),gid=$(id -g),forceuid,forcegid
