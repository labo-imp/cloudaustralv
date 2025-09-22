#!/bin/bash
source  /home/$USER/cloud-install/sh/common.sh

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

MIHOST=$(echo $HOSTNAME | /usr/bin/cut -d . -f1)

if [[ $MIHOST == desktop* || $MIHOST == "instance-instalacion" ]]; then
  /home/$USER/install/zulip_enviar.sh  "SHUTDOWN SOFT    $HOSTNAME"
  nombrevm=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
  zonavm=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
  gcloud --quiet compute instances stop $nombrevm --zone=$zonavm  --project=$MY_PROJECT_ID
else
  /home/$USER/install/zulip_enviar.sh  "SHUTDOWN EVAPORATE    $HOSTNAME"
  nombrevm=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
  zonavm=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
  gcloud --quiet compute instances delete $nombrevm --zone=$zonavm  --project=$MY_PROJECT_ID
fi
