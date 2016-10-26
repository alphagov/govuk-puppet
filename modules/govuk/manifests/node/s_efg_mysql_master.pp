# == Class: govuk::node::s_efg_mysql_master
#
# Configure a MySQL Master server for EFG
#
# === Parameters
#
# [*replica_password*]
#   MySQL replication password
#
# [*root_password*]
#   MySQL root password
#
class govuk::node::s_efg_mysql_master (
  $replica_password,
  $root_password,
) inherits govuk::node::s_base {

  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class { 'govuk_mysql::server::master':
    replica_pass => $replica_password,
  }

  class {'govuk::apps::efg::db':
    require => Class['govuk_mysql::server'],
  }

  class {'govuk::apps::efg_rebuild::db':
    require => Class['govuk_mysql::server'],
  }

  class {'govuk::apps::efg_training::db':
    require => Class['govuk_mysql::server'],
  }

  class {'govuk::apps::efg_training_rebuild::db':
    require => Class['govuk_mysql::server'],
  }

  Govuk_mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
}
