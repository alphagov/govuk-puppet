class govuk_node::backup {
    include govuk_node::base
    include backup::server

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

#    backup::directory {'backup_aggregated_logstash_logging':
#        directory => '/data/logging/logstash-aggregation',
#        host_name => 'logging',
#        fq_dn     => 'logging.management.production',
#    }

}
