class clamav::service {
  $enable_service = $::govuk_platform ? {
    'development' => stopped,
    default       => running,
  }

  service { ['clamav-freshclam', 'clamav-daemon']:
    ensure  => $enable_service,
  }
}
