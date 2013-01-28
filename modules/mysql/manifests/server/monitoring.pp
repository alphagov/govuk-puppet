class mysql::server::monitoring ($root_password) {

  package { 'python-mysqldb':
    ensure => installed,
  }

  @ganglia::pyconf { 'mysql':
    source  => 'puppet:///modules/mysql/ganglia/mysql.pyconf',
  }

  @ganglia::pymod { 'DBUtil':
    source  => 'puppet:///modules/mysql/ganglia/DBUtil.py',
  }

  @ganglia::pymod { 'mysql':
    source  => 'puppet:///modules/mysql/ganglia/mysql.py',
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
    check_command       => 'check_ganglia_metric!mysql_connections!50!100',
    service_description => "mysql high cur conn",
    host_name           => $::fqdn,
  }

  @@nagios::check { "check_mysql_max_connections_${::hostname}":
    check_command       => 'check_ganglia_metric!mysql_max_used_connections!350!400',
    service_description => "mysql high max conn",
    host_name           => $::fqdn,
  }

  @logstash::collector { 'mysql':
    source  => 'puppet:///modules/mysql/etc/logstash/logstash-client/mysql.conf',
  }

}
