class clamav::config {
  file { '/opt/clamav/etc/clamd.conf':
    ensure => present,
    source => 'puppet:///modules/clamav/opt/clamav/etc/clamd.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
