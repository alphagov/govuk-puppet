class apollo {
  include java

  exec { 'download apollo':
    command => '/usr/bin/curl -o apache-apollo-1.0-unix-distro.tar.gz https://gds-public-readable-tarballs.s3.amazonaws.com/apache-apollo-1.0-unix-distro.tar.gz',
    cwd     => '/usr/local/src',
    creates => '/usr/local/src/apache-apollo-1.0-unix-distro.tar.gz',
    require => Package['curl'],
    timeout => 3600,
    unless  => '/usr/bin/test `/usr/bin/md5sum -q /usr/local/src/apache-apollo-1.0-unix-distro.tar.gz` = "7388ff240b48acabcd6ec6859dbbbff6"',
  }

  exec { 'unpack apollo':
    require => Exec['download apollo'],
    creates => '/usr/local/src/apache-apollo-1.0',
    cwd     => '/usr/local/src',
    command => '/bin/tar -xzf ./apache-apollo-1.0-unix-distro.tar.gz'
  }

  exec { 'create broker':
    require => [
      Exec['unpack apollo'],
      Class['java' ]
    ],
    creates => '/usr/local/src/broker',
    cwd     => '/usr/local/src/apache-apollo-1.0',
    command => '/usr/local/src/apache-apollo-1.0/bin/apollo create /usr/local/src/broker'
  }

  file { '/etc/init.d/broker':
    ensure  => link,
    target  => '/usr/local/src/broker/bin/apollo-broker-service',
    require => Exec['create broker']
  }

  file { '/usr/local/src/broker/etc/apollo.xml':
    ensure  => present,
    source  => 'puppet:///modules/apollo/apollo.xml',
    require => Exec['create broker']
  }

  service { 'broker':
    ensure   => running,
    provider => base,
    start    => '/etc/init.d/broker start && sleep 5',
    pattern  => 'apollo',
    require  => [
      File['/etc/init.d/broker'],
      File['/usr/local/src/broker/etc/apollo.xml']
    ]
  }

}
