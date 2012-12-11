class mysql::server::config($server_id = '1', $config_path = 'mysql/master/my.cnf', $platform = $::govuk_platform) {
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
}
