class govuk_node::mapit_server inherits govuk_node::base {
  include postgres::postgis
  include mapit

  postgres::user {'mapit':
      ensure   => present,
      password => 'mapit',
  }

  wget::fetch {'mapit_dbdump_download':
      source      => 'http://cdnt.samsharpe.net/mapit.sql.gz',
      destination => '/data/vhost/mapit/data/mapit.sql.gz',
      require     => File['/data/vhost/mapit/data'],
  }
  postgres::database { 'mapit':
      ensure   => present,
      owner    => 'mapit',
      encoding => 'UTF8',
      source   => '/data/vhost/mapit/data/mapit.sql.gz',
      template => 'template0',
      require  => [ Postgres::User['mapit'], Wget::Fetch['mapit_dbdump_download'] ],
  }
}
