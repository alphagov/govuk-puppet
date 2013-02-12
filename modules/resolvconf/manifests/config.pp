class resolvconf::config {
  file { '/etc/resolvconf/resolv.conf.d/head':
    ensure => present,
    source => 'puppet:///modules/resolvconf/etc/resolvconf/resolv.conf.d/head',
  }
}
