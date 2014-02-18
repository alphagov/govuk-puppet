class govuk_mysql::server (
  $root_password='',
  $tmp_table_size='128M',
  $max_heap_table_size='128M',
  $innodb_file_per_table=false,
  $expire_log_days=3
  ){

  $mysql_error_log = '/var/log/mysql/error.log'

  anchor { 'govuk_mysql::server::begin':
    before => Class['govuk_mysql::server::package'],
    notify => Class['govuk_mysql::server::service'];
  }

  class { 'govuk_mysql::server::package':
    notify => Class['govuk_mysql::server::service'];
  }

  class { 'govuk_mysql::server::config':
    require               => Class['govuk_mysql::server::package'],
    notify                => Class['govuk_mysql::server::service'],
    error_log             => $mysql_error_log,
    expire_log_days       => $expire_log_days,
    tmp_table_size        => $tmp_table_size,
    max_heap_table_size   => $max_heap_table_size,
    innodb_file_per_table => $innodb_file_per_table,
  }

  class { 'govuk_mysql::server::logging':
    error_log => $mysql_error_log,
  }

  # This needs to *not* be required by anchors so that it can use govuk_mysql::user,
  # which requires govuk_mysql::server
  class { 'govuk_mysql::server::debian_sys_maint_user':
    root_password => $root_password,
  }

  class { 'govuk_mysql::server::firewall':
    require => Class['govuk_mysql::server::config'],
  }

  class { 'govuk_mysql::server::service': }

  class { 'govuk_mysql::server::monitoring':
    root_password => $root_password,
    require       => Class['govuk_mysql::server::service'],
  }

  # Don't need to wait for monitoring class
  anchor { 'govuk_mysql::server::end':
    require => Class[
      'govuk_mysql::server::firewall',
      'govuk_mysql::server::service'
    ],
  }

  exec { 'set-mysql-password':
    unless  => "/usr/bin/mysqladmin -uroot -p${root_password} status",
    path    => ['/bin', '/usr/bin'],
    command => "mysqladmin -uroot password ${root_password}",
    require => Class['govuk_mysql::server::service'],
  }

}
