# == Class: govuk::node::s_backup
#
# Node definition for a backup machine.
#
# === Parameters
#
# [*directories*]
#   A hash defining which directories should be backed up.
#
# [*offsite_backups*]
#   Set true to enable to offsite backups
#
class govuk::node::s_backup (
  $directories = {},
  $offsite_backups = false,
) inherits govuk::node::s_base {
  validate_bool($offsite_backups)

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

  if $offsite_backups {
    include backup::offsite
  }
  create_resources('backup::directory', $directories)

}
