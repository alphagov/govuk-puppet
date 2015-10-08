# == Class: clamav
#
# Install and setup the ClamAV antivirus on a machine.
#
# === Parameters
#
# [*use_service*]
#   Boolean indicating whether or not ClamAV should be set up
#   as a constantly running service.
#
class clamav (
    $use_service = true
  ) {

  validate_bool($use_service)

  anchor { 'clamav::begin':
    notify  => Class['clamav::service'],
  }

  class { 'clamav::package':
    notify      => Class[
      'clamav::config',
      'clamav::run_freshclam'
    ],
    use_service => $use_service,
    require     => Anchor['clamav::begin'],
  }

  class { 'clamav::config':
    notify  => Class['clamav::service'],
    require => Class['clamav::package'],
  }

  class { 'clamav::run_freshclam':
    require => Class['clamav::config'],
  }

  class { 'clamav::service':
    use_service => $use_service,
    require     => Class['clamav::run_freshclam'],
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
