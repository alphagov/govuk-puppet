# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_whitehall_mysql_backup inherits govuk::node::s_whitehall_mysql_slave {
  class { 'backup::mysql':
    mysql_dump_password => hiera('mysql_root',''),
    require             => Govuk_mount['/var/lib/automysqlbackup'],
  }
}
