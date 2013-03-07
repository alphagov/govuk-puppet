class clamav::package {
  package { 'clamav':
    ensure => '0.97.5',
  }

  $symlink_target = $::govuk_platform ? {
    'development' => "/opt/clamav/bin/clamscan",
    default       => "/opt/clamav/bin/clamdscan",
  }
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => $symlink_target,
    require => Package['clamav'],
  }
}
