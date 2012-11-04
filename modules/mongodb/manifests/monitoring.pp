class mongodb::monitoring {

  package { 'pymongo':
    ensure   => present,
    provider => 'pip';
  }

  @ganglia::pyconf { 'mongodb':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.conf',
  }

  @ganglia::pymod { 'mongodb':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.py',
  }

  @nagios::plugin { 'check_mongodb.py':
    source  => 'puppet:///modules/mongodb/nagios_check_mongodb.py',
  }

  @nagios::nrpe_config { 'check_mongo':
    source  => 'puppet:///modules/mongodb/nrpe_check_mongo.cfg',
  }

  @@nagios::check { "check_mongod_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mongod',
    service_description => "mongod not running",
  }

  @@nagios::check { "check_mongod_responds_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!connect 2 4',
    service_description => "mongod not responding",
  }

  @@nagios::check { "check_mongod_lock_percentage_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!lock 5 10',
    service_description => "mongod high lock pct",
  }

  @logstash::collector { 'mongodb':
    source  => 'puppet:///modules/mongodb/etc/logstash/logstash-client/mongodb.conf',
  }

  @logstash::pattern { 'mongodb':
    source  => 'puppet:///modules/mongodb/etc/logstash/grok-patterns/mongodb-pattern',
  }

}
