class govuk::node::s_backup {
    include govuk::node::s_base

    class {'backup::server':
      require => Ext4mount['/data/backups'],
    }

    ext4mount {'/data/backups':
      mountoptions => 'errors=remount-ro',
      disk         => '/dev/sdb1',
    }

    @@nagios::check { "check_data_backups_disk_space_${::hostname}":
      check_command       => 'check_nrpe!check_disk_space_arg!20% 10% /data/backups',
      service_description => 'low available disk space on /data/backups',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-space',
    }

    @@nagios::check { "check_data_backups_disk_inodes_${::hostname}":
      check_command       => 'check_nrpe!check_disk_inodes_arg!20% 10% /data/backups',
      service_description => 'low available disk inodes on /data/backups',
      use                 => 'govuk_high_priority',
      host_name           => $::fqdn,
      notes_url           => 'https://github.gds/pages/gds/opsmanual/2nd-line/nagios.html#low-available-disk-inodes',
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

    backup::directory {'backup_mongodb_backups_exception-handler-1':
        directory => '/var/lib/automongodbbackup/',
        host_name => 'exception-handler-1',
        fq_dn     => 'exception-handler-1.management.production',
    }

    backup::directory {'backup_mysql_backups_mysql':
        directory => '/var/lib/automysqlbackup/',
        host_name => 'mysql-slave-1',
        fq_dn     => 'mysql-slave-1.backend.production',
    }

    backup::directory {'backup_mysql_backups_efg_mysql':
        directory => '/var/lib/automysqlbackup/',
        host_name => 'efg-mysql-slave-1',
        fq_dn     => 'efg-mysql-slave-1.efg.production',
    }

}
