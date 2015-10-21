# == Class: clamav::package
#
# Install the packages required to run ClamAV.
#
# === Parameters
#
# [*use_service*]
#   Boolean indicating whether ClamAV should be set up
#   as a service, and if so use the ClamAV daemon client.
#
class clamav::package (
    $use_service
  ) {
  package { ['clamav', 'clamav-freshclam', 'clamav-daemon']:
    ensure  => 'latest',
  }

  if $use_service {
    $symlink_target = '/usr/bin/clamdscan'
  } else {
    $symlink_target = '/usr/bin/clamscan'
  }

  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => $symlink_target,
    require => Package['clamav'],
  }
}
