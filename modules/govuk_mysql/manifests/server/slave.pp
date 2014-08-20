# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_mysql::server::slave {

  include ::govuk_mysql::server::monitoring::slave

  file { '/etc/mysql/conf.d/slave.cnf':
    source => 'puppet:///modules/govuk_mysql/etc/mysql/conf.d/slave.cnf',
    notify => Class['mysql::server::service'],
  }

}
