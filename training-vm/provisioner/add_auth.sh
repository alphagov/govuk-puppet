#!/bin/bash
sed -i '/location[^\^]*{/a\
\
\ \ \ \ auth_basic "Restricted";\
\ \ \ \ auth_basic_user_file /etc/nginx/.htpasswd;\
\
' $1
