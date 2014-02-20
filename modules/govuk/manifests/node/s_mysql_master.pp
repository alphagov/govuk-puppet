class govuk::node::s_mysql_master inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')
  $replica_password = extlookup('mysql_replica_password', '')

  class { 'govuk_mysql::server':
    root_password => $root_password,
  }
  class { 'govuk_mysql::server::binlog': }

  govuk_mysql::user { 'replica_user@%':
    password_hash => mysql_password($replica_password),
    table         => '*.*',
    privileges    => ['SUPER', 'REPLICATION CLIENT', 'REPLICATION SLAVE'],
  }

  class { [
    'govuk::apps::contacts::db',
    'govuk::apps::content_planner::db',
    'govuk::apps::need_o_tron::db',
    'govuk::apps::release::db',
    'govuk::apps::signon::db',
    'govuk::apps::tariff_admin::db',
    'govuk::apps::tariff_api::db',
    'govuk::apps::tariff_api_temporal::db',
    'govuk::apps::transition::db',
    'govuk::apps::whitehall::db'
    ]:
  }

  govuk_mysql::user { 'whitehall_fe@%':
    password_hash => mysql_password(extlookup('mysql_whitehall_frontend', '')),
    table         => 'whitehall_production.*',
    privileges    => ['SELECT'],
    require       => Class['govuk::apps::whitehall::db'],
  }

  govuk_mysql::user { 'bouncer@%':
    password_hash => mysql_password(extlookup('mysql_bouncer', '')),
    table         => 'transition_production.*',
    privileges    => ['SELECT'],
    require       => Class['govuk::apps::transition::db'],
  }

  collectd::plugin::tcpconn { 'mysql':
    incoming => 3306,
    outgoing => 3306,
  }

  #FIXME: remove if when we have moved to platform one
  if hiera(use_hiera_disks,false) {
    Govuk::Mount['/var/lib/mysql'] -> Class['govuk_mysql::server']
  }
}
