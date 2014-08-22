# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_mysql::server::master (
  $replica_pass
) {

  govuk_mysql::user { 'replica_user@%':
    password_hash => mysql_password($replica_pass),
    table         => '*.*',
    privileges    => ['SUPER', 'REPLICATION CLIENT', 'REPLICATION SLAVE'],
  }

  class { '::govuk_mysql::server::monitoring::master': }

  file { '/etc/mysql/conf.d/binlog.cnf':
    source => 'puppet:///modules/govuk_mysql/etc/mysql/conf.d/binlog.cnf',
    notify => Class['mysql::server::service'],
  }

}
