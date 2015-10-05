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
# [*backup_licensify*]
#   Boolean indicating whether or not the Licensify Mongo database
#   should be backed up.
#
class govuk::node::s_backup (
  $directories = {},
  $backup_efg = true,
  $backup_email_campaign = true,
  $backup_licensify = true,
) inherits govuk::node::s_base {

  validate_bool($backup_efg)
  validate_bool($backup_licensify)

  class {'backup::server':
    require => Govuk::Mount['/data/backups'],
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

  $internal_tld = hiera('internal_tld')

  if $backup_efg {
    backup::directory {'backup_mysql_backups_efg_mysql':
      directory => '/var/lib/automysqlbackup/',
      fq_dn     => "efg-mysql-slave-1.efg.${internal_tld}",
      priority  => '002',
    }
  }

  if $backup_licensify {
    backup::directory {'backup_mongodb_backups_licensify_mongo':
      directory => '/var/lib/automongodbbackup/',
      fq_dn     => "licensify-mongo-1.licensify.${internal_tld}",
      priority  => '002',
    }
  }

  if $backup_email_campaign {
    backup::directory {'backup_mongodb_backups_email_campaign_mongo':
      directory => '/var/lib/automongodbbackup/',
      fq_dn     => "email-campaign-mongo-1.api.${internal_tld}",
      priority  => '001',
    }
  }
}
