class mysql::server::monitoring ($root_password) {

  package { 'python-mysqldb':
    ensure => installed,
  }

  # FIXME [#45082195]: No longer required.
  exec { 'grant-ganglia-mysql-access':
    onlyif  => '/usr/bin/mysql -h 127.0.0.1 -uganglia -pganglia',
    command => "/usr/bin/mysql -h 127.0.0.1 -uroot -p${root_password} -e \"DROP USER ganglia@'localhost';\"",
  }

  @@nagios::check { "check_mysqld_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mysqld',
    service_description => "mysqld not running",
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_mysql_connections_${::hostname}":
    check_command       => "check_graphite_metric!${::fqdn_underscore}.mysql.threads-connected!250!350",
    service_description => "mysql high cur conn",
    host_name           => $::fqdn,
  }

  collectd::plugin::mysql { 'lazy_eval_workaround':
    master        => false,
    slave         => false,
    root_password => $root_password,
    require       => Exec['set-mysql-password'],
  }

}
