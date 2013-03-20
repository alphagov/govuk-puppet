class mysql::server::monitoring ($root_password) {

  package { 'python-mysqldb':
    ensure => installed,
  }

  exec { 'grant-ganglia-mysql-access':
    unless  => '/usr/bin/mysql -h 127.0.0.1 -uganglia -pganglia',
    command => "/usr/bin/mysql -h 127.0.0.1 -uroot -p${root_password} -e \"grant USAGE,PROCESS,SUPER,REPLICATION CLIENT on *.* to ganglia@'localhost' identified by 'ganglia'; flush privileges;\"",
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

}
