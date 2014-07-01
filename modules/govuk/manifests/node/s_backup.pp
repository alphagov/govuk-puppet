class govuk::node::s_backup (
  $backup_efg = true,
  $offsite_backups = false,
) inherits govuk::node::s_base {

  validate_bool($backup_efg, $offsite_backups)

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

  if $offsite_backups {
    include backup::offsite
  }

  backup::directory {'backup_mongodb_backups_exception_handler_1':
    directory => '/var/lib/automongodbbackup/',
    host_name => 'exception-handler-1',
    fq_dn     => 'exception-handler-1.backend.production',
  }

  backup::directory {'backup_mongodb_backups_mongo':
    directory => '/var/lib/automongodbbackup/',
    host_name => 'mongo-1',
    fq_dn     => 'mongo-1.backend.production',
  }

  backup::directory {'backup_mongodb_backups_licensify_mongo':
    directory => '/var/lib/automongodbbackup/',
    host_name => 'licensify-mongo-1',
    fq_dn     => 'licensify-mongo-1.licensify.production',
  }

  backup::directory {'backup_mongodb_backups_router_backend':
    directory => '/var/lib/automongodbbackup/',
    host_name => 'router-backend-1',
    fq_dn     => 'router-backend-1.router.production',
  }

  backup::directory {'backup_mysql_backups_mysql_backup_1':
    directory => '/var/lib/automysqlbackup/',
    host_name => 'mysql-backup-1',
    fq_dn     => 'mysql-backup-1.backend.production',
  }

  backup::directory {'backup_mysql_backups_support_contacts_mysql':
    directory => '/var/lib/automysqlbackup/',
    host_name => 'support-contacts-1',
    fq_dn     => 'support-contacts-1.backend.production',
  }

  if $backup_efg {
    backup::directory {'backup_mysql_backups_efg_mysql':
      directory => '/var/lib/automysqlbackup/',
      host_name => 'efg-mysql-slave-1',
      fq_dn     => 'efg-mysql-slave-1.efg.production',
    }
  }
}
