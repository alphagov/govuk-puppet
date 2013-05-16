class mysql::server::monitoring::master ($root_password) inherits mysql::server::monitoring {
  Collectd::Plugin::Mysql['lazy_eval_workaround'] {
    master => true,
  }

  $nagios_mysql_password = extlookup('mysql_nagios')

  mysql::user { 'nagios':
    root_password => $root_password,
    user_password => $nagios_mysql_password,
    remote_host   => 'localhost',
    privileges    => 'REPLICATION CLIENT',
  }
}
