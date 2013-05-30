class clamav::package {
  package { ['clamav', 'clamav-freshclam', 'clamav-daemon']:
    ensure  => 'latest',
  }

  $symlink_target = $::govuk_platform ? {
    'development' => '/usr/bin/clamscan',
    default       => '/usr/bin/clamdscan',
  }
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => $symlink_target,
    require => Package['clamav'],
  }
}
