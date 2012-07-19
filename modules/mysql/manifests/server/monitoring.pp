class mysql::server::monitoring ($root_password){

  include ganglia::client
  include nagios::client

  package {'python-mysqldb':
    ensure => installed,
  }

  file { '/etc/ganglia/conf.d/mysql.pyconf':
    source  => 'puppet:///modules/mysql/ganglia/mysql.pyconf',
    require => Service['mysql'],
    notify  => Service['ganglia-monitor'],
  }

  file { '/usr/lib/ganglia/python_modules/DBUtil.py':
    source  => 'puppet:///modules/mysql/ganglia/DBUtil.py',
    mode    => '0755',
    require => [Service['mysql'],Service['ganglia-monitor']]
  }

  file { '/usr/lib/ganglia/python_modules/mysql.py':
    source  => 'puppet:///modules/mysql/ganglia/mysql.py',
    mode    => '0755',
    require => [Service['mysql'],Service['ganglia-monitor']]
  }

  exec { 'grant-ganglia-mysql-access':
    unless  => '/usr/bin/mysql -h 127.0.0.1 -uganglia -pganglia',
    command => "/usr/bin/mysql -h 127.0.0.1 -uroot -p${root_password} -e \"grant USAGE,PROCESS,SUPER,REPLICATION CLIENT on *.* to ganglia@'localhost' identified by 'ganglia'; flush privileges;\"",
    require => Class[mysql::server],
  }

  @@nagios::check { "check_mysqld_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!mysqld',
    service_description => "check mysqld running on ${::govuk_class}-${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_mysql_connections_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ganglia_metric!mysql_connections!50!90',
    service_description => "check mysql connections for ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

  @@nagios::check { "check_mysql_max_connections_${::hostname}":
    use                 => 'generic-service',
    check_command       => 'check_ganglia_metric!mysql_max_used_connections!75!90',
    service_description => "check mysql max connections for ${::hostname}",
    host_name           => "${::govuk_class}-${::hostname}",
  }

}
