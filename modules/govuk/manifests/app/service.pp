define govuk::app::service (
  $ensure = 'present',
) {

  $enable_service = str2bool(hiera('govuk_app_enable_services', 'yes'))

  if $ensure == 'absent' {
    service { $title:
      ensure   => stopped,
      provider => 'base',
      pattern  => $title,
    }
  } else {
    service { $title:
      provider => 'upstart',
    }
    if $enable_service {
      Service[$title] {
        ensure => running
      }
    }
  }

}
