# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_mysql::server::firewall {
  @ufw::allow { 'allow-mysqld-from-all':
    port => 3306,
  }
}
