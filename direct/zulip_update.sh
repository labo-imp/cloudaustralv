#!/bin/bash

source /home/$USER/install/common.sh
source /home/$USER/install/secrets.sh

/usr/bin/curl -X PATCH $zulipurl/api/v1/messages/$1 \
    -u $zulipbot \
    --data-urlencode 'content= '"$2"'.'
