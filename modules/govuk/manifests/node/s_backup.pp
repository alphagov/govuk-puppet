# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_backup (
  $backup_efg = true,
) inherits govuk::node::s_base {

  validate_bool($backup_efg)

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

  backup::directory {'backup_mongodb_backups_api_mongo':
    directory => '/var/lib/automongodbbackup/',
    host_name => 'api-mongo-1',
    fq_dn     => 'api-mongo-1.api.production',
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

  backup::directory {'backup_mysql_backups_whitehall_mysql_backup_1':
    directory => '/var/lib/automysqlbackup/',
    host_name => 'whitehall-mysql-backup-1',
    fq_dn     => 'whitehall-mysql-backup-1.backend.production',
  }

  backup::directory {'backup_postgresql_backups_postgresql_slave_1':
    directory => '/var/lib/autopostgresqlbackup/',
    host_name => 'postgresql-slave-1',
    fq_dn     => 'postgresql-slave-1.backend.production',
  }

  backup::directory {'backup_postgresql_backups_puppetmaster_postgresql':
    directory => '/var/lib/autopostgresqlbackup/',
    host_name => 'puppetmaster-1',
    fq_dn     => 'puppetmaster-1.management.production',
  }

  backup::directory {'backup_postgresql_backups_transition_postgresql_slave_1':
    directory => '/var/lib/autopostgresqlbackup/',
    host_name => 'transition-postgresql-slave-1',
    fq_dn     => 'transition-postgresql-slave-1.backend.production',
  }

  backup::directory {'backup_graphite_storage_whisper_graphite-1':
    directory => '/opt/graphite/backup',
    host_name => 'graphite-1',
    fq_dn     => 'graphite-1.management.production',
  }

  if $backup_efg {
    backup::directory {'backup_mysql_backups_efg_mysql':
      directory => '/var/lib/automysqlbackup/',
      host_name => 'efg-mysql-slave-1',
      fq_dn     => 'efg-mysql-slave-1.efg.production',
    }
  }
}
