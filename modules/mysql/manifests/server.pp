class mysql::server($root_password='', $tmp_table_size='128M', $max_heap_table_size='128M') {

  $mysql_error_log = '/var/log/mysql/error.log'

  anchor { 'mysql::server::begin':
    before => Class['mysql::server::package'],
    notify => Class['mysql::server::service'];
  }

  class { 'mysql::server::package':
    notify => Class['mysql::server::service'];
  }

  class { 'mysql::server::config':
    require             => Class['mysql::server::package'],
    notify              => Class['mysql::server::service'],
    error_log           => $mysql_error_log,
    tmp_table_size      => $tmp_table_size,
    max_heap_table_size => $max_heap_table_size,
  }

  class { 'mysql::server::logging':
    error_log => $mysql_error_log,
  }

  # This needs to *not* be required by anchors so that it can use mysql::user,
  # which requires mysql::server
  class { 'mysql::server::debian_sys_maint_user':
    root_password => $root_password,
  }

  class { 'mysql::server::firewall':
    require => Class['mysql::server::config'],
  }

  class { 'mysql::server::service': }

  class { 'mysql::server::monitoring':
    root_password => $root_password,
    require       => Class['mysql::server::service'],
  }

  # Don't need to wait for monitoring class
  anchor { 'mysql::server::end':
    require => Class[
      'mysql::server::firewall',
      'mysql::server::service'
    ],
  }

  cron { 'daily sql tarball':
    ensure  => absent,
  }

  exec { 'set-mysql-password':
    unless  => "/usr/bin/mysqladmin -uroot -p${root_password} status",
    path    => ['/bin', '/usr/bin'],
    command => "mysqladmin -uroot password ${root_password}",
    require => Class['mysql::server::service'],
  }

}
