# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
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
