class apollo {
  include java

  exec { 'download apollo':
    command => "/usr/bin/curl -O http://apache.mirrors.timporter.net/activemq/activemq-apollo/1.0/apache-apollo-1.0-unix-distro.tar.gz",
    cwd => "/usr/local/src",
    creates => "/usr/local/src/apache-apollo-1.0-unix-distro.tar.gz",
    require => Package['curl'],
    timeout => 3600
  }

  exec { 'unpack apollo':
    require => Exec['download apollo'],
    creates => "/usr/local/src/apache-apollo-1.0",
    cwd => "/usr/local/src",
    command => "/bin/tar -xzf ./apache-apollo-1.0-unix-distro.tar.gz"
  }

  exec { 'create broker':
    require => [ Exec['unpack apollo'], Class['java' ] ],
    creates => '/usr/local/src/broker',
    cwd => "/usr/local/src/apache-apollo-1.0",
    command => "/usr/local/src/apache-apollo-1.0/bin/apollo create /usr/local/src/broker"
  }

  file { '/etc/init.d/broker':
    ensure => link,
    target => '/usr/local/src/broker/bin/apollo-broker-service',
    require => Exec['create broker']
  }

  file { '/usr/local/src/broker/etc/apollo.xml':
    source => 'puppet:///modules/apollo/apollo.xml',
    ensure => present,
    require => Exec['create broker']
  }

  service { 'broker':
    provider => base,
    ensure => running,
    start => '/etc/init.d/broker start && sleep 5',
    pattern => 'apollo',
    require => [ File['/etc/init.d/broker'], File['/usr/local/src/broker/etc/apollo.xml'] ]
  }

}
