class clamav::package {
  # FIXME: Remove once upgraded to v0.9.97 in Ubuntu upstream.
  #
  # This tidies up after an old internally-built package which doesn't tidy
  # up after itself - passwd entry and dir ownership.
  #
  # - https://github.com/alphagov/packages/blob/master/clamav.sh
  # - http://gds-packages.s3-website-us-east-1.amazonaws.com/
  #
  exec { 'remove_custom_clamav_package':
    command => '/sbin/stop clamav-daemon; /usr/bin/apt-get -q -y purge clamav; /usr/sbin/userdel clamav',
    onlyif  => '/usr/bin/test "$(dpkg-query -Wf \'${Package}:${Version}:${Maintainer}\' clamav 2>/dev/null)" = "clamav:0.97.5:<vagrant@vm>"',
  }

  package { ['clamav', 'clamav-freshclam', 'clamav-daemon']:
    ensure  => 'latest',
    require => Exec['remove_custom_clamav_package'],
  }

  $symlink_target = $::govuk_platform ? {
    'development' => "/usr/bin/clamscan",
    default       => "/usr/bin/clamdscan",
  }
  file { '/usr/local/bin/govuk_clamscan':
    ensure  => symlink,
    target  => $symlink_target,
    require => Package['clamav'],
  }
}
