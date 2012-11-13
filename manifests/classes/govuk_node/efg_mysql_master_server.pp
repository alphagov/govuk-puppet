class govuk_node::efg_mysql_master_server inherits govuk_node::base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')
  $master_server_id = '1'

  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $master_server_id
  }

  mysql::user {'replica_user':
    root_password  => $root_password,
    user_password  => $replica_password,
    privileges     => 'SUPER, REPLICATION CLIENT, REPLICATION SLAVE',
  }

  @@backup::directory {"backup_mysql_backups_$::hostname":
    directory => '/var/lib/automysqlbackup/',
    host_name => $::hostname,
    fq_dn     => $::fqdn,
  }

  class {'govuk::apps::efg::db':
    require => Class['mysql::server']
  }
}
