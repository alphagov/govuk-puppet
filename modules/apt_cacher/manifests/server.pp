class apt_cacher::server {
  
  package {'apt-cacher':
    ensure => installed,
  }

  file {'/etc/default/apt-cacher':
    ensure  => present,
    source  => 'puppet:///modules/apt_cacher/etc/default/apt-cacher',
    require => Package['apt-cacher'],
    notify  => Service['apt-cacher'],
  }

  service {'apt-cacher':
    ensure  => running,
    require => Package['apt-cacher'],
    notify  => Class['apt_cacher::client'],
  }

}
