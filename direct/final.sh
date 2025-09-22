#!/bin/bash
# fecha revision   2025-09-22  13:55

source  /home/$USER/install/common.sh

printf  "\n\nIniciando la parte final de la instalacion\n"

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

MIHOST=$(echo $HOSTNAME | cut -d . -f1)
MIZONA=$(gcloud compute instances list --filter=$MIHOST --format='value(ZONE)')

printf "\n borrando imagen image-dm vieja en caso que hubiera quedado como resabio de intento de instalacion anterior\n\n"
gcloud compute images delete image-dm  --quiet  --verbosity=none  --project=$MY_PROJECT_ID

printf  '\n\n\n\n'
printf  'Esperando a que termine la instalacion de paquetes lentos de R\n\n'
/home/$USER/install/semaforo  wait  /sem_xgboost
/home/$USER/install/semaforo  wait  /sem_lightgbm
/home/$USER/install/semaforo  wait  /sem_lentosR

printf  '\nPaquetes lentos de R instalados\n'


printf  "\n\nCreando la imagen del sistema operativo, esto va a demorar 6 minutos.\n"
printf  "Le va a parecer que no se esta haciendo nada, pero ESPERE esos 6 minutos ! \nNo se impaciente ! \n\n"

gcloud compute images create image-dm   \
       --source-disk=$MIHOST            \
       --source-disk-zone=$MIZONA       \
       --storage-location=us            \
       --project=$MY_PROJECT_ID         \
       --force

bitacora   "vm image"

printf  '\nun gran paso : imagen creada.\n\n'

#------------------------------------------------------------------------------


MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

SEAC=$(gcloud iam service-accounts list --filter=Compute --format='value(EMAIL)')
echo $SEAC



# 8vcpu  32 GB RAM
gcloud beta compute instance-templates delete temp-08vcpu-032ram  --region=northamerica-northeast2 --quiet  --verbosity=none  --project=$MY_PROJECT_ID

gcloud beta compute instance-templates create temp-08vcpu-032ram    \
       --project=$MY_PROJECT_ID                                     \
       --machine-type=custom-8-32768-ext                            \
       --network-interface=network=default,network-tier=PREMIUM     \
       --no-restart-on-failure --maintenance-policy=TERMINATE       \
       --provisioning-model=SPOT                                    \
       --instance-termination-action=DELETE                         \
       --service-account=$SEAC                                      \
       --scopes=cloud-platform                                      \
       --tags=http-server,https-server                              \
       --instance-template-region=northamerica-northeast2           \
       --create-disk=auto-delete=yes,boot=yes,device-name=temp-08vcpu-032ram,image=image-dm,mode=rw,size=256,type=pd-standard \
       --shielded-secure-boot  \
       --shielded-integrity-monitoring --reservation-affinity=any   \
       --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh


# 8vcpu  64 GB RAM
gcloud compute instance-templates delete temp-08vcpu-064ram  --region=northamerica-northeast2 --quiet  --verbosity=none  --project=$MY_PROJECT_ID

gcloud compute instance-templates create temp-08vcpu-064ram         \
       --project=$MY_PROJECT_ID                                     \
       --machine-type=custom-8-65536-ext                            \
       --network-interface=network=default,network-tier=PREMIUM     \
       --no-restart-on-failure --maintenance-policy=TERMINATE       \
       --provisioning-model=SPOT                                    \
       --instance-termination-action=DELETE                         \
       --service-account=$SEAC                                      \
       --scopes=cloud-platform                                      \
       --tags=http-server,https-server                              \
       --instance-template-region=northamerica-northeast2           \
       --create-disk=auto-delete=yes,boot=yes,device-name=temp-08vcpu-064ram,image=image-dm,mode=rw,size=256,type=pd-standard \
       --shielded-secure-boot                                       \
       --shielded-integrity-monitoring --reservation-affinity=any   \
       --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh


# 8vcpu  128 GB RAM
gcloud compute instance-templates delete temp-08vcpu-128ram  --region=northamerica-northeast2 --quiet  --verbosity=none  --project=$MY_PROJECT_ID

gcloud compute instance-templates create temp-08vcpu-128ram         \
       --project=$MY_PROJECT_ID                                     \
       --machine-type=custom-8-131072-ext                           \
       --network-interface=network=default,network-tier=PREMIUM     \
       --no-restart-on-failure --maintenance-policy=TERMINATE       \
       --provisioning-model=SPOT                                    \
       --instance-termination-action=DELETE                         \
       --service-account=$SEAC                                      \
       --scopes=cloud-platform                                      \
       --tags=http-server,https-server                              \
       --instance-template-region=northamerica-northeast2           \
       --create-disk=auto-delete=yes,boot=yes,device-name=temp-08vcpu-128ram,image=image-dm,mode=rw,size=256,type=pd-standard \
       --shielded-secure-boot                                       \
       --shielded-integrity-monitoring --reservation-affinity=any   \
       --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh



# 8vcpu  256 GB RAM
gcloud compute instance-templates delete temp-08vcpu-256ram  --region=northamerica-northeast2 --quiet  --verbosity=none  --project=$MY_PROJECT_ID

gcloud compute instance-templates create temp-08vcpu-256ram         \
       --project=$MY_PROJECT_ID                                     \
       --machine-type=custom-8-262144-ext                           \
       --network-interface=network=default,network-tier=PREMIUM     \
       --no-restart-on-failure --maintenance-policy=TERMINATE       \
       --provisioning-model=SPOT                                    \
       --instance-termination-action=DELETE                         \
       --service-account=$SEAC                                      \
       --scopes=cloud-platform                                      \
       --tags=http-server,https-server                              \
       --instance-template-region=northamerica-northeast2           \
       --create-disk=auto-delete=yes,boot=yes,device-name=temp-08vcpu-256ram,image=image-dm,mode=rw,size=256,type=pd-standard \
       --shielded-secure-boot                                       \
       --shielded-integrity-monitoring --reservation-affinity=any   \
       --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh


# 8vcpu  512 GB RAM
gcloud compute instance-templates delete temp-08vcpu-512ram  --region=northamerica-northeast2 --quiet  --verbosity=none  --project=$MY_PROJECT_ID

gcloud compute instance-templates create temp-08vcpu-512ram         \
       --project=$MY_PROJECT_ID                                     \
       --machine-type=custom-8-524288-ext                           \
       --network-interface=network=default,network-tier=PREMIUM     \
       --no-restart-on-failure --maintenance-policy=TERMINATE       \
       --provisioning-model=SPOT                                    \
       --instance-termination-action=DELETE                         \
       --service-account=$SEAC                                      \
       --scopes=cloud-platform                                      \
       --tags=http-server,https-server                              \
       --instance-template-region=northamerica-northeast2           \
       --create-disk=auto-delete=yes,boot=yes,device-name=temp-08vcpu-512ram,image=image-dm,mode=rw,size=256,type=pd-standard \
       --shielded-secure-boot                                       \
       --shielded-integrity-monitoring --reservation-affinity=any   \
       --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh

bitacora   "vm templates"

#------------------------------------------------------------------------------

source  /home/$USER/install/common.sh

SEAC=$(gcloud iam service-accounts list --filter=Compute --format='value(EMAIL)')
echo $SEAC

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

# borro desktop por si quedo de alguna instalacion anterior
gcloud compute instances  delete  desktop   --zone=southamerica-east1-c \
       --quiet  --verbosity=none --project=$MY_PROJECT_ID

printf  '\n\n\nIniciando creacion de virtual machine desktop\n\n'

# creo la virtual machine desktop
gcloud compute instances create desktop \
    --project=$MY_PROJECT_ID  \
    --zone=southamerica-east1-c \
    --machine-type=e2-highmem-8  \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --no-restart-on-failure \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD  \
    --service-account=$SEAC \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=http-server,https-server \
    --create-disk=auto-delete=yes,boot=yes,device-name=desktop,image=image-dm,mode=rw,size=192,type=pd-standard \
    --no-shielded-secure-boot  \
    --metadata-from-file shutdown-script=/home/$USER/cloud-install/direct/shutdown-script.sh

printf  '\nvirtual machine  desktop  CREADA\n\n'

printf  '\nesperando 2 minutos para apagar desktop\n\n'
sleep 120

# la detengo
gcloud compute instances  stop  desktop   --zone=southamerica-east1-c  --project=$MY_PROJECT_ID

source  /home/$USER/install/common.sh

bitacora   "desktop creation"

#------------------------------------------------------------------------------

printf  '\n\n\n\n'
read -r -p "TODA instalacion ha terminado. Presione la tecla Enter para finalizar..." key

bitacora   "END  final.sh"

/home/$USER/cloud-install/direct/apagar_vm.sh
