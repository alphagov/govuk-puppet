# == Class: govuk::node::s_backup
#
# Node definition for a backup machine.
#
# === Parameters
#
# [*directories*]
#   A hash defining which directories should be backed up.
#
# [*backup_efg*]
#   Boolean indicating whether or not the EFG MySQL database should
#   be backed up.
#
class govuk::node::s_backup (
  $directories = {},
  $backup_efg = true,
) inherits govuk::node::s_base {

  validate_bool($backup_efg)

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

  $app_domain = hiera('app_domain')

  if $backup_efg {
    backup::directory {'backup_mysql_backups_efg_mysql':
      directory => '/var/lib/automysqlbackup/',
      fq_dn     => "efg-mysql-slave-1.efg.${app_domain}",
      priority  => '002',
    }
  }
}
