# == Class: mongodb::monitoring
#
# Configures monitoring for mongodb
#
# === Parameters
#
# [*dbpath*]
#   Where mongodb stores data on disk
#
class mongodb::monitoring (
  $dbpath = '/var/lib/mongodb'
) {

  include mongodb::python

  # This plugin is from https://github.com/mzupan/nagios-plugin-mongodb
  # to update to the latest version, run this giant command:
  # git subtree pull --prefix=modules/mongodb/files/nagios-plugin-mongodb \
  #   https://github.com/mzupan/nagios-plugin-mongodb.git \
  #   -m 'update to latest nagios-plugin-mongodb from github' master --squash
  @icinga::plugin { 'check_mongodb.py':
    source  => 'puppet:///modules/mongodb/nagios-plugin-mongodb/check_mongodb.py',
  }

  @icinga::nrpe_config { 'check_mongo':
    source  => 'puppet:///modules/mongodb/nrpe_check_mongo.cfg',
  }

  @icinga::plugin { 'check_dir_empty':
    source  => 'puppet:///modules/mongodb/nagios_check_dir_empty',
  }

  @icinga::nrpe_config { 'check_dir_empty':
    source  => 'puppet:///modules/mongodb/nrpe_check_dir_empty.cfg',
  }

  @@icinga::check { "check_mongod_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mongod',
    service_description => 'mongod not running',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_mongod_responds_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!connect 2 4',
    service_description => 'mongod not responding',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_mongod_rollbacks_${::hostname}":
    check_command       => "check_nrpe!check_dir_empty!${dbpath}/rollback",
    service_description => 'mongod rollback dir should be nonexistent',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(mongodb-rollback),
  }

  @@icinga::check { "check_mongod_replication_lag_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!replication_lag 150 300',
    service_description => 'mongod replication lag',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(mongod-replication-lag),
  }

  @@icinga::check { "check_mongod_connections_${::hostname}":
    check_command       =>'check_nrpe!check_mongodb!connections 80 90',
    service_description => 'mongod percentage connection usage',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_mongod_replset_state_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!replset_state',
    service_description => 'mongod replset state',
    host_name           => $::fqdn,
  }
}
