class govuk_node::mysql_master_server inherits govuk_node::base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  include mysql::backup

  class { 'mysql::server':
    root_password => $root_password,
  }
  include mysql::server::binlog

  mysql::user { 'replica_user':
    root_password  => $root_password,
    user_password  => $replica_password,
    privileges     => 'SUPER, REPLICATION CLIENT, REPLICATION SLAVE',
  }

  class {'govuk::apps::signon::db':
    require => Class['mysql::server']
  }
  class {'govuk::apps::need_o_tron::db':
    require => Class['mysql::server']
  }
  class {'govuk::apps::tariff_api::db':
    require => Class['mysql::server']
  }
  class {'govuk::apps::whitehall_admin::db':
    require => Class['mysql::server']
  }

  $whitehall_frontend_password = extlookup('mysql_whitehall_frontend', '')
  mysql::user { 'whitehall_fe':
    root_password => $root_password,
    user_password => $whitehall_frontend_password,
    db            => 'whitehall_production',
    privileges    => 'SELECT',
    require       => Class['govuk::apps::whitehall_admin::db'],
  }

}
