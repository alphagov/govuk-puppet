class mapit {
  mapit::setup{'setup dirs and users':
    mapit_datadir => '/data/vhost/mapit/',
  }
  package{['python-django-south','python-yaml','memcached','python-memcache',
          'python-django','python-psycopg2',
          'python-flup','python-gdal']:
    ensure => present,
  }

  class { 'nginx::config' : node_type => mapit }

  file { '/etc/init/mapit.conf':
    ensure  => file,
    source  => 'puppet:///modules/mapit/fastcgi_mapit.conf',
    require => [
        User['mapit'],
        Exec['unzip_mapit'],
      ]
  }
  file { '/data/vhost/mapit/data/mapit.tar.gz':
    ensure  => file,
    source  => 'puppet:///modules/mapit/mapit.tar.gz',
    before  => Exec['unzip_mapit'],
  }
  exec {'unzip_mapit':
    command => 'tar -zxf /data/vhost/mapit/data/mapit.tar.gz -C /data/vhost/mapit',
    creates => '/data/vhost/mapit/mapit/README',
    user    => 'mapit',
    require => [
        User['mapit'],
        File['/data/vhost/mapit/'],
      ],
  }
  service { 'mapit':
    ensure    => running,
    provider  => upstart,
    subscribe => File['/etc/init/mapit.conf'],
    require   => [
      File['/etc/init/mapit.conf'],
      Exec['unzip_mapit'],
    ],
  }
}
