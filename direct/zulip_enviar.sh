#!/bin/bash

source /home/$USER/install/common.sh

/usr/bin/curl -X POST $zulipurl \
    -u $zulipbot \
    --data-urlencode type=direct \
    --data-urlencode 'to=email' \
    --data-urlencode 'content= '"$1"'.'
