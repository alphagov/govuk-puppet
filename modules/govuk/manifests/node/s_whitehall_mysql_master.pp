class govuk::node::s_whitehall_mysql_master (
  $dump_password
) inherits govuk::node::s_base {
  $replica_password = hiera('mysql_replica_password', '')
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password         => $root_password,
    innodb_file_per_table => true,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class {'govuk::apps::whitehall::db': require => Class['govuk_mysql::server'] }

  govuk_mysql::user { 'whitehall_fe@%':
    password_hash => mysql_password(hiera('mysql_whitehall_frontend', '')),
    table         => 'whitehall_production.*',
    privileges    => ['SELECT'],
    require       => Class['govuk::apps::whitehall::db'],
  }

  govuk_mysql::user { 'dump@localhost':
    password_hash => mysql_password($dump_password),
    table         => '*.*',
    privileges    => ['SELECT', 'LOCK TABLES'],
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  #FIXME: remove if when we have moved to platform one
  if hiera(use_hiera_disks,false) {
    Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
  }
}
