
class mapit_server {
  include wget
  include nginx
  include postgres::postgis
  include mapit

  postgres::user {'mapit':
      ensure   => present,
      password => 'mapit',
  }

  wget::fetch {'mapit_dbdump_download':
      source      => 'http://cdnt.samsharpe.net/mapit.sql.gz',
      destination => '/data/vhosts/mapit/data/mapit.sql.gz',
      require     => File['/data/vhosts/mapit/data/'],
  }
  postgres::database { 'mapit':
      ensure    => present,
      owner     => 'mapit',
      encoding  => 'UTF8',
      template  => 'template_postgis',
      source    => '/data/vhosts/mapit/data/mapit.sql.gz',
      require   => [ Postgres::User['mapit'], Wget::Fetch['mapit_dbdump_download'], Package['postgres-client-common'] ],
  }
}
