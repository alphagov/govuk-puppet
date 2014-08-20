class mapit::package {

  group { 'mapit':
      ensure => present,
      name   => 'mapit',
  }

  user { 'mapit':
      ensure     => present,
      home       => '/home/mapit',
      managehome => true,
      shell      => '/bin/bash',
      gid        => 'mapit',
      require    => Group['mapit'],
  }

  file { '/data/vhost/mapit':
      ensure  => directory,
      owner   => 'mapit',
      group   => 'mapit',
      mode    => '0755',
      require => User['mapit'],
  }

  file { '/data/vhost/mapit/data':
      ensure  => directory,
      owner   => 'mapit',
      group   => 'mapit',
      mode    => '0755',
      require => User['mapit'],
  }

  package { [
            'gdal-bin',
            'memcached',
            'python-beautifulsoup',
            'python-django',
            'python-django-south',
            'python-flup',
            'python-gdal',
            'python-memcache',
            'python-psycopg2',
            'python-shapely',
            'python-yaml'
            ]:
    ensure => present,
  }

  file { '/data/vhost/mapit/data/mapit.tar.gz':
    ensure => file,
    source => 'puppet:///modules/mapit/mapit.tar.gz',
    before => Exec['unzip_mapit'],
  }

  exec {'unzip_mapit':
    command => 'tar -zxf /data/vhost/mapit/data/mapit.tar.gz -C /data/vhost/mapit',
    creates => '/data/vhost/mapit/mapit/README.rst',
    user    => 'mapit',
    require => [
        User['mapit'],
        File['/data/vhost/mapit'],
      ],
  }
}

