define govuk::app::service {

  $enable_service = str2bool(extlookup('govuk_app_enable_services', 'yes'))

  service { $title:
    provider => 'upstart',
  }

  if $enable_service {
    Service[$title] {
      ensure => running
    }
  }

}
