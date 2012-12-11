class mysql::server::config($config_path = 'mysql/master/my.cnf', $platform = $::govuk_platform) {
  file { '/etc/mysql':
    ensure => 'directory'
  }

  file { '/etc/mysql/my.cnf':
    owner    => 'mysql',
    group    => 'mysql',
    content  => template($config_path),
    notify   => Service['mysql'],
    require  => [File['/var/lib/mysql/my.cnf'], File['/etc/mysql']]
  }

  file { '/etc/mysql/conf.d':
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
  }

  # MySQL's server-id MUST be unique for every server in a cluster. That is,
  # each and every server must have a server-id that doesn't conflict with any
  # other server in the cluster.
  #
  # lib/facter/server_id.rb in this module provides a nice way of doing this,
  # by using the IP address of the machine to compute a server-id, and exposes
  # this as a facter fact, "mysql_server_id".
  file { '/etc/mysql/conf.d/serverid.cnf':
    content => "
[mysqld]
server-id = ${::mysql_server_id}
",
  }

}
