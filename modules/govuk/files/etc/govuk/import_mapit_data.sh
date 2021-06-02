#!/bin/bash

set -x

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


function import_db_from_s3 () {
  # get the data from s3
  aws s3 cp --no-sign-request s3://govuk-custom-formats-mapit-storage-production/source-data/2021-05/mapit-may-2021-update.sql.gz /tmp/mapit.sql.gz

  # drop the old db and bring up a new empty one
  sudo -u postgres dropdb --if-exists mapit
  sudo -u postgres createdb --owner mapit mapit
  sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" mapit

  # load up the downloaded data into this new db
  zcat /tmp/mapit.sql.gz | sudo -u postgres psql mapit
}

stop_mapit_services
import_db_from_s3
restart_mapit_services
