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

  # Must trigger a restart of clamd to take effect. Handled by dependencies
  # in the parent class.
  apparmor::profile { 'usr.sbin.clamd':
    local_only   => true,
    local_source => 'puppet:///modules/clamav/etc/apparmor.d/local/usr.sbin.clamd',
  }
}
