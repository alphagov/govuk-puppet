#!/bin/bash

sed -i '/location \/ {/a\
\
\ \ \ \ auth_basic "GOV.UK Training Environment";\
\ \ \ \ auth_basic_user_file /etc/nginx/.htpasswd;\
\
' $1
