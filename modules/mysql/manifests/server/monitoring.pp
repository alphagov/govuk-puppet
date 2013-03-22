class mysql::server::monitoring ($root_password) {

  package { 'python-mysqldb':
    ensure => installed,
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
