class clamav {
  package { 'clamav':
    ensure => '0.97.5',
  }

  service { 'clamav-daemon':
    ensure => 'running',
    enable => 'true',
    require => Package["clamav"]
  }

  file { '/opt/clamav/etc/clamd.conf':
    notify => Service["clamav-daemon"],
    ensure  => present,
    source => 'puppet:///modules/clamav/opt/clamav/etc/clamd.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  
  Package['clamav'] -> File['/opt/clamav/etc/clamd.conf']
}
