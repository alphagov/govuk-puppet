class nagios::client::install {
  $nagios_client_packages = ['nagios-nrpe-plugin', 'nagios-plugins-basic', 'nagios-plugins-standard', 'nagios-nrpe-server']
  package { $nagios_client_packages: ensure => 'installed' }
  file { '/etc/nagios/nrpe.cfg':
    source  => 'puppet:///modules/nagios/nrpe.cfg',
    owner   => root,
    group   => root,
    mode    => '0640',
    notify  => Service[nagios-nrpe-server],
    require => Package[nagios-nrpe-server],
  }
  file { '/usr/local/bin/nrpe-runner':
    source => 'puppet:///modules/nagios/nrpe-runner',
    owner  => root,
    group  => root,
    mode   => '0755',
  }
  package { 'json':
    ensure   => 'installed',
    provider => gem,
  }
  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    source  => 'puppet:///modules/nagios/nrpe.d',
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Service[nagios-nrpe-server],
    require => Package[nagios-nrpe-server],
  }
}
