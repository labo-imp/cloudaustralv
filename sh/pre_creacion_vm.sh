#!/bin/bash
# fecha revision   2025-09-22  13:55

# este script corre en Cloud Shell
printf "\niniciando la instalacion\n\n"

# parametros fundamentales
github_catedra_user="labo-imp"
github_install_repo="cloudaustralv"
gcprojectprefix="laboimp-"
gcprojectname="austral-labo2025"

timestamp=$(date +"%y%m%d%H%M%S%3N")
projectid_nuevo="$gcprojectprefix""$timestamp"

# creo proyecto nuevo
listaprojectos=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE")

if [ "$listaprojectos" = "" ];
then
    printf "\ncreando proyecto\n"
    gcloud projects create $projectid_nuevo --name=$gcprojectname
    sleep 30
    printf "\nproyecto $projectid creado\n"
fi


# parametros fundamentales
github_catedra_user="labo-imp"
github_install_repo="cloudaustralv"
gcprojectprefix="laboimp-"
gcprojectname="austral-labo2025"
MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID


# habilitacion de servicios
gcloud --quiet --project=$MY_PROJECT_ID services enable  iam.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  cloudapis.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  cloudresourcemanager.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  iamcredentials.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  storage-api.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  storage-component.googleapis.com
gcloud --quiet --project=$MY_PROJECT_ID services enable  storage.googleapis.com

printf "\nesperando para establecer billing\n"
sleep  30
MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
accountid=$(gcloud alpha billing accounts list  --format="value(ACCOUNT_ID)")
gcloud beta billing projects link $MY_PROJECT_ID --billing-account=$accountid  --project=$MY_PROJECT_ID

printf "\ndando permisos de Compute\n"
gcloud --quiet --project=$MY_PROJECT_ID services enable  compute.googleapis.com


sleep  60

sudo  DEBIAN_FRONTEND=noninteractive  apt-get update

rm -rf  /home/$USER/install
mkdir  -p  /home/$USER/install
mkdir  -p  /home/$USER/log

sudo  apt-get --yes  install  git rsync

# clono el repo de instalacion
rm -rf /home/$USER/cloud-install
cd
git clone  https://github.com/"$github_catedra_user"/"$github_install_repo".git   cloud-install

# permisos de ejecucion
chmod u+x  /home/$USER/cloud-install/sh/*.sh
chmod u+x  /home/$USER/cloud-install/jl/*.jl
chmod u+x  /home/$USER/cloud-install/direct/*.sh

# despersonalizacion
cp /home/$USER/cloud-install/sh/common.sh /home/$USER/install/

# copia de direct
cp /home/$USER/cloud-install/direct/*   /home/$USER/install/


source  /home/$USER/cloud-install/sh/common.sh
bitacora   "START  instalar.sh"

# tmux vim
/home/$USER/cloud-install/sh/ins_vimtmux.sh


# quitar cran para produccion

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID


myserviceaccount=$(gcloud iam service-accounts list --format='value(EMAIL)' | head -1)


# instance-instalacion STANDARD creacion
gcloud compute instances create instance-instalacion \
    --project="$MY_PROJECT_ID" \
    --zone=us-west4-c \
    --machine-type=t2d-standard-8 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --maintenance-policy=TERMINATE \
    --provisioning-model=STANDARD \
    --service-account="$myserviceaccount" \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=https-server,http-server \
    --create-disk=auto-delete=yes,boot=yes,device-name=instance-instalacion,image=projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20250828,mode=rw,size=64,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any


# verifico que existan buckets, sino creo el primero

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID


mybuckets=$(/bin/gsutil ls)

if [ "$mybuckets" = "" ];
then
    printf "\nNo existen buckets, se creara uno \n\n"
    gcloud storage buckets create gs://"$USER"_bukito3  --location=US  --project "$MY_PROJECT_ID"
fi


echo
echo "Esperando 30 segundos a que se inicie la virtual machine  instance-instalacion"
sleep 30

rm -rf /home/$USER/.ssh
mkdir -p /home/$USER/.ssh
ssh-keygen -t rsa -f  /home/$USER/.ssh/google_compute_engine -C $USER  -q -N ""


MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

gcloud --quiet compute ssh "$USER"@instance-instalacion \
    --zone=us-west4-c \
    --project="$MY_PROJECT_ID" \
    --command="bash -s" < /home/$USER/cloud-install/sh/pre_main01.sh 


echo "Esperando 5 segundos"
sleep 5
printf "\n\nHa finalizado la pre instalacion. Continua con la copia de archivos al bucket.\n\n"