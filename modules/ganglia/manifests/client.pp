class ganglia::client {

  anchor { 'ganglia::client::begin':
    before => Class['ganglia::client::package'],
    notify => Class['ganglia::client::service'],
  }

  class { 'ganglia::client::package':
    notify => Class['ganglia::client::service'],
  }

  class { 'ganglia::client::config':
    require => Class['ganglia::client::package'],
    notify  => Class['ganglia::client::service'],
  }

  class { 'ganglia::client::service': }

  anchor { 'ganglia::client::end':
    require => Class['ganglia::client::service'],
  }

  @ganglia::pymod { 'diskstat':
    source => 'puppet:///modules/ganglia/usr/lib/ganglia/python_modules/diskstat.py',
  }

  @ganglia::pymod { 'procstat':
    source  => 'puppet:///modules/ganglia/usr/lib/ganglia/python_modules/procstat.py',
  }

  Ganglia::Pyconf <| |>
  Ganglia::Pymod <| |>
  Ganglia::Cronjob <| |>
}
