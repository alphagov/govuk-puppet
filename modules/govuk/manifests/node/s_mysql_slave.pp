class govuk::node::s_mysql_slave inherits govuk::node::s_base {
  $root_password = extlookup('mysql_root', '')

  include mysql::backup

  class { 'mysql::server':
    root_password => $root_password,
  }
  include mysql::server::slave

}
