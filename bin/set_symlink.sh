#!/bin/bash
source bin/functions.sh

eval $(parse_yaml profile/variables.yaml "vars_")

currentuser=$(whoami)
if [ ! -h /tmp/etc/nginx/default-site/$vars_Jovian_run_identifier ]
   then
      mkdir -p /tmp/etc/nginx/default-site/
      ln -s "$(pwd)/bin/software/igv.js" "/tmp/etc/nginx/default-site/$vars_Jovian_run_identifier"
fi

find /tmp/etc/nginx/ -user ${currentuser} -exec chmod 777 {} \;