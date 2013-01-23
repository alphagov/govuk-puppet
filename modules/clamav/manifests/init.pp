class clamav {
  anchor { 'clamav::begin':
    notify  => Class['clamav::service'],
  }
  class { 'clamav::package':
    notify  => Class['clamav::config'],
    require => Anchor['clamav::begin'],
  }
  class { 'clamav::config':
    notify  => Class['clamav::service'],
    require => Class['clamav::package'],
  }
  class { 'clamav::service': }
  anchor { 'clamav::end':
    require => Class['clamav::service'],
  }
}
