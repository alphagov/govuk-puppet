# == Class: govuk::node::s_backup
#
# Node definition for a backup machine.
#
# === Parameters
#
# [*directories*]
#   A hash defining which directories should be backed up.
#
class govuk::node::s_backup (
  $directories = {},
) inherits govuk::node::s_base {

  class {'backup::server':
    require => Govuk_mount['/data/backups'],
  }

  # To accommodate futzing around with databases, we install a MySQL server
  $root_password = hiera('mysql_root', '')
  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class {'govuk::apps::whitehall::db':
    require => Class['govuk_mysql::server'],
  }

  include backup::offsite

  create_resources('backup::directory', $directories)

}
