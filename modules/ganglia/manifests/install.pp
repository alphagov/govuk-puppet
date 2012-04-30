class ganglia::install {
  package {
    'ganglia-webfrontend': ensure => 'installed';
  }
  file { '/etc/apache2/sites-enabled/ganglia':
    ensure  => present,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/ganglia/apache.conf',
    require => Package[ganglia-webfrontend],
  }
  file { '/etc/ganglia/gmetad.conf':
    source  => 'puppet:///modules/ganglia/gmetad.conf',
    owner   => root,
    group   => root,
    require => Package[ganglia-webfrontend],
  }
}
