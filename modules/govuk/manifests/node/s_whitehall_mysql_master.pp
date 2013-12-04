class govuk::node::s_whitehall_mysql_master inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  class { 'mysql::server':
    root_password         => $root_password,
    innodb_file_per_table => true,
  }
  class { 'mysql::server::binlog':
    root_password => $root_password,
  }

  mysql::user { 'replica_user':
    root_password  => $root_password,
    user_password  => $replica_password,
    privileges     => 'SUPER, REPLICATION CLIENT, REPLICATION SLAVE',
  }

  class {'govuk::apps::whitehall::db': require => Class['mysql::server'] }

  mysql::user { 'whitehall_fe':
    root_password => $root_password,
    user_password => extlookup('mysql_whitehall_frontend', ''),
    db            => 'whitehall_production',
    privileges    => 'SELECT',
    require       => Class['govuk::apps::whitehall::db'],
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

}
