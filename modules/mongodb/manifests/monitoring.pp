class mongodb::monitoring ($dbpath = '/var/lib/mongodb') {

  include mongodb::python

  @nagios::plugin { 'check_mongodb.py':
    source  => 'puppet:///modules/mongodb/nagios_check_mongodb.py',
  }

  @nagios::nrpe_config { 'check_mongo':
    source  => 'puppet:///modules/mongodb/nrpe_check_mongo.cfg',
  }

  @nagios::plugin { 'check_dir_empty':
    source  => 'puppet:///modules/mongodb/nagios_check_dir_empty',
  }

  @nagios::nrpe_config { 'check_dir_empty':
    source  => 'puppet:///modules/mongodb/nrpe_check_dir_empty.cfg',
  }

  @@nagios::check { "check_mongod_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mongod',
    service_description => 'mongod not running',
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_mongod_responds_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!connect 2 4',
    service_description => 'mongod not responding',
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_mongod_lock_percentage_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!lock 5 10',
    service_description => 'mongod high lock pct',
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_mongod_rollbacks_${::hostname}":
    check_command       => "check_nrpe!check_dir_empty!${dbpath}/rollback",
    service_description => 'mongod rollback dir should be nonexistent',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#mongodb-rollback',
  }

  @@nagios::check { "check_mongod_replication_lag_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!replication_lag 150 300',
    service_description => 'mongod replication lag',
    host_name           => $::fqdn,
    notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#mongod-replication-lag',
  }

  @@nagios::check { "check_mongod_connections_${::hostname}":
    check_command       =>'check_nrpe!check_mongodb!connections 80 90',
    service_description => 'mongod percentage connection usage',
    host_name           => $::fqdn,
  }
}
