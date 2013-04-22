class clamav {
  anchor { 'clamav::begin':
    notify  => Class['clamav::service'],
  }

  class { 'clamav::package':
    notify  => Class[
      'clamav::config',
      'clamav::run_freshclam'
    ],
    require => Anchor['clamav::begin'],
  }

  class { 'clamav::config':
    notify  => Class['clamav::service'],
    require => Class['clamav::package'],
  }

  class { 'clamav::run_freshclam':
    require => Class['clamav::config'],
  }

  class { 'clamav::service':
    require => Class['clamav::run_freshclam'],
  }

  class { 'clamav::monitoring':
    require => Class['clamav::config'],
  }

  anchor { 'clamav::end':
    require => Class[
      'clamav::service',
      'clamav::monitoring'
    ],
  }
}
