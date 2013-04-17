class clamav::config {
  file { '/etc/clamav/clamd.conf':
    ensure => present,
    source => 'puppet:///modules/clamav/etc/clamd.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/clamav/freshclam.conf':
    ensure => present,
    source => 'puppet:///modules/clamav/etc/freshclam.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
