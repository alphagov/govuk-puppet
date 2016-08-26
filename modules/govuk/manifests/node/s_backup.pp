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
# [*backup_email_campaign*]
#   Boolean indicating whether or not the email-campaign-api Mongo database
#   should be backed up.
#
class govuk::node::s_backup (
  $directories = {},
  $backup_efg = true,
  $backup_email_campaign = true,
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

  backup::directory {'backup_mongodb_backups_licensify_mongo':
    directory => '/var/lib/automongodbbackup/',
    fq_dn     => "licensify-mongo-1.licensify.${app_domain}",
    priority  => '002',
  }

  if $backup_email_campaign {
    backup::directory {'backup_mongodb_backups_email_campaign_mongo':
      directory => '/var/lib/automongodbbackup/',
      fq_dn     => "email-campaign-mongo-1.api.${app_domain}",
      priority  => '001',
    }
  }
}
