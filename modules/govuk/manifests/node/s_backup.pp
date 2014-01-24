class govuk::node::s_backup {
    include govuk::node::s_base

    class {'backup::server':
      require => Govuk::Mount['/data/backups'],
    }

    govuk::mount { '/data/backups':
      mountoptions => 'errors=remount-ro',
      disk         => '/dev/sdb1',
    }

    #To accommodate futzing around with databases, we install a MySQL server
    $root_password = extlookup('mysql_root', '')
    class { 'mysql::server':
      root_password => $root_password,
    }
    class {'govuk::apps::whitehall::db':       require => Class['mysql::server'] }

    $offsite_backup = extlookup('offsite-backups', 'off')

    case $offsite_backup {
      'on':    { include backup::offsite }
      default: {}
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

    backup::directory {'backup_mongodb_backups_exception-handler-1':
        directory => '/var/lib/automongodbbackup/',
        host_name => 'exception-handler-1',
        fq_dn     => 'exception-handler-1.management.production',
    }

    backup::directory {'backup_mysql_backups_mysql_backup_1':
        directory => '/var/lib/automysqlbackup/',
        host_name => 'mysql-backup-1',
        fq_dn     => 'mysql-backup-1.backend.production',
    }

    backup::directory {'backup_mysql_backups_efg_mysql':
        directory => '/var/lib/automysqlbackup/',
        host_name => 'efg-mysql-slave-1',
        fq_dn     => 'efg-mysql-slave-1.efg.production',
    }

    backup::directory {'backup_mysql_backups_support_contacts_mysql':
        directory => '/var/lib/automysqlbackup/',
        host_name => 'support-contacts-1',
        fq_dn     => 'support-contacts-1.backend.production',
    }
}
