# == Class: mapit::package
#
# Install mapit dependencies.
#
class mapit::package () {

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
            'python-gdal',
            'python-psycopg2',
            ]:
    ensure => present,
  }

  # FIXME: Remove once these packages are absent in production
  package {
    [
      'python-beautifulsoup',
      'python-django',
      'python-django-south',
      'python-flup',
      'python-memcache',
      'python-shapely',
      'python-yaml'
    ]:
    ensure => absent,
  }

  $pip_packages = {
    'BeautifulSoup'    => {'ensure' => '3.2.0'},
    'Django'           => {'ensure' => '1.3.1'},
    'flup'             => {'ensure' => '1.0.2'},
    'python_memcached' => {'ensure' => '1.48'},
    'PyYAML'           => {'ensure' => '3.10'},
    'Shapely'          => {'ensure' => '1.2.14'},
    'South'            => {'ensure' => '0.7.3'},
  }

  create_resources('package', $pip_packages, {
    provider => 'pip',
  })

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

