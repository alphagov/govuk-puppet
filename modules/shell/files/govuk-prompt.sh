#!/bin/bash
MYIP=`curl -s icanhazip.com`
case $MYIP in
  217.171.99.70)
    MYENV="production";
    ;;
  217.171.99.78)
    MYENV="staging";
    ;;
  217.171.99.86)
    MYENV="preview";
    ;;
  *)
    MYENV=""
    ;;
esac
