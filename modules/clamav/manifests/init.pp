class clamav {
  package { 'clamav':
    ensure => '0.97.5',
  }

  service { 'clamav-daemon':
    ensure  => 'running',
    require => Package["clamav"]
  }

  file { '/opt/clamav/etc/clamd.conf':
    ensure => present,
    notify => Service["clamav-daemon"],
    source => 'puppet:///modules/clamav/opt/clamav/etc/clamd.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  Package['clamav'] -> File['/opt/clamav/etc/clamd.conf']
}
