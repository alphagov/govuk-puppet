class ganglia::client::install {
  package {
    'ganglia-monitor': ensure => 'installed';
  }
  file { '/etc/ganglia/gmond.conf':
    source  => 'puppet:///modules/ganglia/gmond.conf',
    owner   => root,
    group   => root,
    require => Package[ganglia-monitor],
  }
}
