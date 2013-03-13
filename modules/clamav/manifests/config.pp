class clamav::config {
  file { '/opt/clamav/etc/clamd.conf':
    ensure => present,
    source => 'puppet:///modules/clamav/opt/clamav/etc/clamd.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/opt/clamav/etc/freshclam.conf':
    ensure => present,
    source => 'puppet:///modules/clamav/opt/clamav/etc/freshclam.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
