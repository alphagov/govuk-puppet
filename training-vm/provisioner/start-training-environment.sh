#!/bin/bash

cd "$(dirname "$0")"

# Start all apps that are required in the training environment.
# Takes either a file of app names, or from stdin.

while read app
do
  sudo service $app start
done < "${1:-/dev/stdin}"
