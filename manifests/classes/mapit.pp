class mapit_server {
  include wget
  include postgres::postgis
  include mapit

  postgres::user {'mapit':
      ensure   => present,
      password => 'mapit',
  }

  postgres::database { 'mapit':
      ensure   => present,
      owner    => 'mapit',
      encoding => 'UTF8',
      template => 'template_postgis',
      require  => Postgres::User['mapit'],
  }

}
