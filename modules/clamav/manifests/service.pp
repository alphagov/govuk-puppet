class clamav::service {

  $enable_service = ($::govuk_platform != 'development')

  file { "/etc/init/clamav-daemon.conf":
    content => template('clamav/etc/init/clamav-daemon.conf.erb'),
    notify  => Service['clamav-daemon'],
  }

  service { 'clamav-daemon':
    ensure   => $enable_service,
    provider => 'upstart',
  }
}
