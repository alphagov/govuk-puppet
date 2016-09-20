# Configure a MySQL Master server for EFG
class govuk::node::s_efg_mysql_master inherits govuk::node::s_base {
  $replica_password = hiera('mysql_replica_password', '')
  $root_password = hiera('mysql_root', '')

  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class {'govuk::apps::efg::db':
    require => Class['govuk_mysql::server'],
  }

  class {'govuk::apps::efg_training::db':
    require => Class['govuk_mysql::server'],
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
