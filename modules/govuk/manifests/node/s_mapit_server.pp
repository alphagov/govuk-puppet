# == Class: govuk::node::s_mapit_server
#
# Node definition for a Mapit server.
#
# TODO: rename 'mapit_server' to simply 'mapit'
#
# === Parameters
#
# [*postgresql_password*]
#   Password for the `mapit` PostgreSQL user.
#
class govuk::node::s_mapit_server (
  $postgresql_password,
) inherits govuk::node::s_base {

  include mapit

  Govuk_mount['/var/lib/postgresql']
  ->
  class { 'govuk_postgresql::server::standalone': }
  postgresql::server::config_entry { 'standard_conforming_strings':
    value => 'off',
  }
  class { 'postgresql::server::postgis':
  }

  govuk_postgresql::db { 'mapit':
    user     => 'mapit',
    password => $postgresql_password,
    encoding => 'UTF8',
  }
  ->
  curl::fetch { 'mapit_dbdump_download':
    # See modules/mapit/manifests/README.md for instructions to update this dump
    source      => 'https://gds-public-readable-tarballs.s3.amazonaws.com/mapit-October2015-add-gss-code-for-northern-ireland-EUR.sql.gz',
    destination => '/data/vhost/mapit/data/mapit.sql.gz',
    sha         => 'abb2b28ca6cd296cef3e2309affd0179070396f3',
    require     => File['/data/vhost/mapit/data'],
  }
  ->
  exec { 'load the mapit data':
    user        => 'postgres',
    environment => ['PGDATABASE=mapit'],
    command     => 'zcat -f /data/vhost/mapit/data/mapit.sql.gz | psql',
    unless      => 'psql -Atc "select count(*) from pg_catalog.pg_tables WHERE tablename=\'mapit_area\'" | grep -qvF 0',
    notify      => Class['mapit::service'],
  }

}
