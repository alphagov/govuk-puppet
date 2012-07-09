class mongodb::monitoring {

  include ganglia::client
  include nagios::client
  
  package { 'python-pip':
    ensure => present,
  }

  package { 'build-essential':
    ensure => present,
  }
  
  package { 'python-dev':
    ensure => present,
  }

  exec { 'install-pymongo': 
    command  => 'pip install pymongo',
    require  => [Package['python-pip'],Package['build-essential'],Package['python-dev']]
  }

  file { '/etc/ganglia/conf.d/mongodb.pyconf':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.conf',
    require => [Service['mongodb'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/ganglia/python_modules/mongodb.py':
    source  => 'puppet:///modules/mongodb/ganglia_mongodb.py',
    mode    => '0755',
    require => [Service['mongodb'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/nagios/plugins/check_mongodb.py':
    source  => 'puppet:///modules/mongodb/nagios_check_mongodb.py',
    mode    => '0755',
    require => [Service['mongodb'],Package['nagios-nrpe-server'],Exec['install-pymongo']]
  }

  file { '/etc/nagios/nrpe.d/check_mongo.cfg':
    source  => 'puppet:///modules/mongodb/nrpe_check_mongo.cfg',
    require => [Service['mongodb'],Package['nagios-nrpe-server']]
  }

  @@nagios::check { "check_mongod_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mongod',
    service_description => "check mongod running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_mongod_responds_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!connect!2!4',
    service_description => "check mongod responds on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_mongod_lock_percentage_${::hostname}":
    check_command       => 'check_nrpe!check_mongodb!connect!5!10',
    service_description => "check mongod lock percentage on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
