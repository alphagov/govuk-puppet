class mysql::server($root_password='') {

  anchor { 'mysql::server::begin':
    before => Class['mysql::server::package'],
    notify => Class['mysql::server::service'];
  }

  class { 'mysql::server::package':
    notify => Class['mysql::server::service'];
  }

  class { 'mysql::server::config':
    require => Class['mysql::server::package'],
    notify  => Class['mysql::server::service'];
  }

  class { 'mysql::server::service':
  }

  class { 'mysql::server::monitoring':
    root_password => $root_password,
    require       => Class['mysql::server::service'],
  }

  # Don't need to wait for monitoring class
  anchor { 'mysql::server::end':
    require => Class['mysql::server::service'],
  }

  cron { 'daily sql tarball':
    ensure  => present,
    command => 'for d in `find /var/lib/automysqlbackup/daily -mindepth 1 -maxdepth 1 -type d`; do ls -1tr $d/* | tail -1; done | sudo xargs tar cf /var/lib/automysqlbackup/daily.tar 2>/dev/null',
    user    => 'root',
    minute  => 13,
    hour    => 7,
    require => Class['mysql::server::package'],
  }

  exec { 'set-mysql-password':
    unless  => "/usr/bin/mysqladmin -uroot -p${root_password} status",
    path    => ['/bin', '/usr/bin'],
    command => "mysqladmin -uroot password ${root_password}",
    require => Class['mysql::server::service'],
  }

}
