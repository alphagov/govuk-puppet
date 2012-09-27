#!/bin/bash
MYIP=`curl -s icanhazip.com`
case $MYIP in
  217.171.99.70)
    MYENV="production-";
    ;;
  217.171.99.78)
    MYENV="staging-"
    ;;
  *)
    MYENV=""
    ;;
esac
PS1="[\u@${MYENV}\h \W]\$ "
