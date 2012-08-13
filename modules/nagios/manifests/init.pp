class nagios {

  anchor { 'nagios::begin':
    before => Class['nagios::package'],
    notify => Class['nagios::service'];
  }

  class { 'nagios::package':
    notify => Class['nagios::service'];
  }

  class { 'nagios::config':
    require => Class['nagios::package'],
    notify  => Class['nagios::service'];
  }

  class { 'nagios::service': }

  anchor { 'nagios::end':
    require => Class['nagios::service'],
  }

  Nagios::Host   <<||>> { notify => Class['nagios::service'] }
  Nagios::Check  <<||>> { notify => Class['nagios::service'] }
}

