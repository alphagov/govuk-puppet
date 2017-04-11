#!/bin/bash

GPG_PASS=$(cat /vagrant/duplicity_passphrase)

for MYSQLDB in mysql-backup-1.backend whitehall-mysql-backup-1.backend
do
  mkdir -p /var/backups/mysql/${MYSQLDB}.integration
  PASSPHRASE=${GPG_PASS} duplicity restore --file-to-restore data/backups/${MYSQLDB}.integration.publishing.service.gov.uk/var/lib/automysqlbackup/latest.tbz2 s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-integration/govuk-datastores/ /var/backups/mysql/${MYSQLDB}.integration/latest.tbz2
done

for MONGODB in api-mongo-1.api mongo-1.backend router-backend-1.router
do
  mkdir -p /var/backups/mongo/${MONGODB}.integration
  PASSPHRASE=${GPG_PASS} duplicity restore --file-to-restore data/backups/${MONGODB}.integration.publishing.service.gov.uk/var/lib/automongodbbackup/latest/ s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-integration/govuk-datastores/ /var/backups/mongo/${MONGODB}.integration/
done

for POSTGRESDB in postgresql-master-1.backend transition-postgresql-master-1.backend
do
  mkdir -p /var/backups/postgresql/${POSTGRESDB}.integration
  PASSPHRASE=${GPG_PASS} duplicity restore --file-to-restore data/backups/${POSTGRESDB}.integration.publishing.service.gov.uk/var/lib/autopostgresqlbackup/latest.tbz2 s3://s3-eu-west-1.amazonaws.com/govuk-offsite-backups-integration/govuk-datastores/ /var/backups/postgresql/${POSTGRESDB}.integration/latest.tbz2
done

cd /var/govuk/govuk-puppet/development-vm/replication
./replicate-data-local.sh -s -d /var/backups -i signon -e

/var/govuk/govuk-puppet/training-vm/es-restore-s3.sh
