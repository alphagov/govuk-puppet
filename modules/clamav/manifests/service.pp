class clamav::service {

  $enable_service = ($::govuk_platform != 'development')

  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure  => $enable_service,
  }
}
