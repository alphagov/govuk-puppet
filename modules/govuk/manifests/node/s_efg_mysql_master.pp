class govuk::node::s_efg_mysql_master (
  $dump_password
) inherits govuk::node::s_base {
  $replica_password = hiera('mysql_replica_password', '')
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class {'govuk::apps::efg::db':
    require => Class['govuk_mysql::server']
  }

  govuk_mysql::user { 'dump@localhost':
    password_hash => mysql_password($dump_password),
    table         => '*.*',
    privileges    => ['SELECT', 'LOCK TABLES', 'SHOW DATABASES'],
  }

  Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
