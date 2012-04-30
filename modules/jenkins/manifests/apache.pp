class jenkins::apache {
  jenkins::apache::a2enmod { 'proxy': }
  jenkins::apache::a2enmod { 'proxy_http': }

  $port = '80'

  package { 'apache2':
    ensure => installed,
  }
    service { 'apache2':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['apache2']
  }

  file { '/etc/apache2/ports.conf':
    ensure  => present,
    content => template('apache2/ports.conf'),
    require => Package['apache2'],
    notify  => Service['apache2'],
  }

  exec { 'apache_graceful':
    command     => 'apache2ctl graceful',
    refreshonly => true,
    onlyif      => 'apache2ctl configtest',
  }

  file { '/etc/apache2/sites-available/default':
    ensure  => present,
    source  => 'puppet:///modules/jenkins/vhost',
    force   => true,
    require => [Package['apache2'], Exec['a2enmod proxy'], Exec['a2enmod proxy_http']],
    notify  => Exec['apache_graceful'],
  }

  file { '/etc/apache2/sites-available/default-ssl':
    ensure => absent,
    force  => true,
    notify => Exec['apache_graceful'],
  }
}
