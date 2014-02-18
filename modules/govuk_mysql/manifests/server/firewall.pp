class govuk_mysql::server::firewall {
  @ufw::allow { 'allow-mysqld-from-all':
    port => 3306,
  }
}
