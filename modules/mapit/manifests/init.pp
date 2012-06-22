class mapit {
  mapit::get_data{'get_recent_data':
    mapit_datadir => '/data/vhosts/mapit',
  }
  package{['python-django-south','python-yaml','memcached','python-memcache',
          'git-core','python-pip','python-django','python-psycopg2',
          'python-flup','nginx','python-gdal']:
    ensure => present,
  }
}
