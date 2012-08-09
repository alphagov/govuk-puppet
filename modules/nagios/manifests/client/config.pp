class nagios::client::config {

  file { '/etc/nagios/nrpe.cfg':
    source => 'puppet:///modules/nagios/nrpe.cfg',
    mode   => '0640',
  }

  file { '/usr/local/bin/nrpe-runner':
    source => 'puppet:///modules/nagios/nrpe-runner',
    mode   => '0755',
  }

  file { '/etc/nagios/nrpe.d':
    ensure  => directory,
    source  => 'puppet:///modules/nagios/nrpe.d',
    recurse => true,
    purge   => true,
    force   => true,
  }

}
