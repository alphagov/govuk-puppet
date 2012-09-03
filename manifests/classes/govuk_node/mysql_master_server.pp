class govuk_node::mysql_master_server inherits govuk_node::base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')
  $master_server_id = '1'

  class { 'mysql::server':
    root_password => $root_password,
    server_id     => $master_server_id
  }

  # TODO: PP 2012-08-17: push replica_user into mysql::server
  class {'mysql::server::replica_user':
    host           => 'localhost',
    root_password  => $root_password,
    password       => $replica_password,
    require        => Class['mysql::server'],
  }

  class {'govuk::apps::signonotron::db':
    require => Class['mysql::server']
  }
  class {'govuk::apps::need_o_tron::db':
    require => Class['mysql::server']
  }
  class {'govuk::apps::tariff_api::db':
    require => Class['mysql::server']
  }
}
