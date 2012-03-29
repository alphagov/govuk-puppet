class sysctl {
  file { '/etc/sysctl.d/10-disable-timestamps.conf':
    source => 'puppet:///modules/sysctl/10-disable-timestamps.conf',
    owner  => root,
    group  => root,
  }
}
