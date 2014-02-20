class govuk::node::s_whitehall_mysql_master inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  class { 'govuk_mysql::server':
    root_password         => $root_password,
    innodb_file_per_table => true,
  }
  class { 'govuk_mysql::server::binlog': }

  govuk_mysql::user { 'replica_user@%':
    password_hash => mysql_password($replica_password),
    table         => '*.*',
    privileges    => ['SUPER', 'REPLICATION CLIENT', 'REPLICATION SLAVE'],
  }

  class {'govuk::apps::whitehall::db': require => Class['govuk_mysql::server'] }

  govuk_mysql::user { 'whitehall_fe@%':
    password_hash => mysql_password(extlookup('mysql_whitehall_frontend', '')),
    table         => 'whitehall_production.*',
    privileges    => ['SELECT'],
    require       => Class['govuk::apps::whitehall::db'],
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
