class icinga::client::config {

  file { '/etc/nagios/nrpe.cfg':
    source => 'puppet:///modules/icinga/etc/nagios/nrpe.cfg',
    mode   => '0640',
  }

  file { '/usr/local/bin/nrpe-runner':
    source => 'puppet:///modules/icinga/usr/local/bin/nrpe-runner',
    mode   => '0755',
  }

  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    source  => 'puppet:///modules/icinga/etc/nagios/nrpe.d',
    recurse => true,
    purge   => true,
    force   => true,
  }

}
