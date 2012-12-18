class govuk::node::mapit_server inherits govuk::node::base {

  include postgres
  include postgres::postgis

  include mapit

  wget::fetch { 'mapit_dbdump_download':
    source      => 'http://gds-public-readable-tarballs.s3.amazonaws.com/mapit.sql.gz',
    destination => '/data/vhost/mapit/data/mapit.sql.gz',
    require     => File['/data/vhost/mapit/data'],
  }

  postgres::user {'mapit':
    password => 'mapit',
  }

  postgres::database { 'mapit':
    ensure   => present,
    owner    => 'mapit',
    encoding => 'UTF8',
    template => 'template0',
  }

  postgres::exec { 'zcat -f /data/vhost/mapit/data/mapit.sql.gz | psql':
    database => 'mapit',
    unless   => "psql -Atc \"select count(*) from pg_catalog.pg_tables WHERE tablename='mapit_area'\" | grep -qvF 0",
    require  => Wget::Fetch['mapit_dbdump_download'],
  }

}
