# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_efg_mysql_slave inherits govuk::node::s_mysql_slave {
  class { 'backup::mysql':
    mysql_dump_password => hiera('mysql_root',''),
  }
}
