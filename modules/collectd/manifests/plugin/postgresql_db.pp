# == Define: collectd::plugin::postgresql
#
# Monitor a postgresql database.
#
define collectd::plugin::postgresql_db() {
  include collectd::plugin::postgresql
  @collectd::plugin { "postgresql-${title}":
    content => template('collectd/etc/collectd/conf.d/postgresql_db.conf.erb'),
  }
  @postgresql::server::database_grant { "${title}-collectd-CONNECT":
    privilege => 'CONNECT',
    db        => $title,
    role      => 'collectd',
    tag       => 'govuk_postgresql::server::not_slave',
  }
}
