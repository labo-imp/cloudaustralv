#!/bin/bash

source  /home/$USER/cloud-install/sh/common.sh

MY_PROJECT_ID=$(gcloud projects list --filter="projectId~$gcprojectprefix AND lifecycleState:ACTIVE" --format="value(projectId)")
gcloud config set project $MY_PROJECT_ID

gcloud compute ssh "$USER"@instance-instalacion \
    --zone=us-west4-c \
    --project="$MY_PROJECT_ID" \
    --command="bash -s" <  /home/$USER/cloud-install/sh/ins_tmux_main02.sh
