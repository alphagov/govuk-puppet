# TODO: rename 'mapit_server' to simply 'mapit'
class govuk::node::s_mapit_server inherits govuk::node::s_base {


  include mapit

  Govuk::Mount['/var/lib/postgresql']
  ->
  class { 'govuk_postgresql::server': }
  postgresql::server::config_entry { 'standard_conforming_strings':
    value => 'off',
  }
  class { 'postgresql::server::postgis':
  }

  govuk_postgresql::db { 'mapit':
    user     => 'mapit',
    password => 'mapit',
    encoding => 'UTF8',
  }
  ->
  curl::fetch { 'mapit_dbdump_download':
    source      => 'http://gds-public-readable-tarballs.s3.amazonaws.com/mapit.sql.gz',
    destination => '/data/vhost/mapit/data/mapit.sql.gz',
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
