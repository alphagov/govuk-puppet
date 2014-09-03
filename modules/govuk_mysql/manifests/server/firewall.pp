# == Class: govuk_mysql::server::firewall
#
# Allow access to port 3306 from everywhere.
#
class govuk_mysql::server::firewall {
  @ufw::allow { 'allow-mysqld-from-all':
    port => 3306,
  }
}
