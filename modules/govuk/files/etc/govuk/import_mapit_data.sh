#!/bin/bash

function stop_mapit_services () {
  # Stop Mapit Services
  sudo service nginx stop
  # Stop mapit and collectd which are using the Mapit database so that we can drop it
  sudo service mapit stop
  sudo service collectd stop
  # # Make sure that cached mapit responses are cleared when the database is updated
  sudo service memcached restart
}

function restart_mapit_services () {
  # Restart Mapit Services
  sudo service collectd start
  sudo service mapit start
  sudo service nginx start
}

stop_mapit_services
# This script needs to run as a user that can sudo to become the postgres
# user.  It's easiest if this is passwordless, so we can't use the deploy user
# who can't sudo without a password
# Run 'govuk_setenv mapit ./import-db-from-s3.sh' from the '/var/apps/mapit' as

cd /var/apps/mapit && govuk_setenv mapit ./import-db-from-s3.sh
restart_mapit_services
