#!/bin/bash
# fecha revision   2025-09-22  13:55

logito="ins_datasets.txt"
# si ya corrio esta seccion, exit

# requiero que el system este instalado
[ ! -e "/home/$USER/log/ins_system.txt" ] && exit 1


source  /home/$USER/cloud-install/sh/common.sh

# copio pseudopublic  a list
cd  /home/$USER/install
wget  $webfiles/$pseudopublic  -O  list
chmod u+x  /home/$USER/install/list


mkdir  -p  /home/$USER/datasets
mkdir  -p  /home/$USER/buckets/b1/datasets
mkdir  -p  /home/$USER/buckets/b1/exp
mkdir  -p  /home/$USER/buckets/b1/log

cd /home/$USER/datasets/
find . -type f -size 0b -delete

cd  /home/$USER/buckets/b1/datasets
find . -type f -size 0b -delete


if [ ! -e "$dataset1" ]; then
  wget --quiet --tries=3  $webfiles/"$dataset1"  -O  "$dataset1"
  if [ ! $? -eq 0 ]; then
    rm  "$dataset1"
  fi
fi

if [ ! -e "$dataset2" ]; then
  wget --quiet --tries=3  $webfiles/"$dataset2"  -O  "$dataset2"
  if [ ! $? -eq 0 ]; then
    rm  $dataset2
  fi
fi

if [ ! -e "$dataset3" ]; then
  wget --quiet  --tries=3  $webfiles/"$dataset3"  -O  "$dataset3"
  if [ ! $? -eq 0 ]; then
    rm  $dataset3
  fi
fi

if [ ! -e "$dataset4" ]; then
  wget --quiet --tries=3  $webfiles/"$dataset4"  -O  "$dataset4"
  if [ ! $? -eq 0 ]; then
    rm  $dataset4
  fi
fi


cp /home/$USER/buckets/b1/datasets/*   /home/$USER/datasets


cd

bitacora   "datasets"

# grabo
fecha=$(date +"%Y%m%d %H%M%S")
echo $fecha > /home/$USER/log/$logito
