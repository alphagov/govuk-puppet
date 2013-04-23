class clamav::service {

  $enable_service = ($::govuk_platform != 'development')

  # FIXME: Old package files to be removed.
  file { [
    '/etc/init/clamav-daemon.conf',
    '/etc/cron.d/clamav-freshclam',
    '/etc/cron.d/clamav-freshclam.dpkg-old'
    ]:
    ensure => absent,
  }

  service {
    'clamav-freshclam':
      ensure  => $enable_service;
    'clamav-daemon':
      ensure  => $enable_service,
      require => File['/etc/init/clamav-daemon.conf'];
  }
}
