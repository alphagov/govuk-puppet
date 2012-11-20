define govuk::app::service($platform) {

  service { $title:
    provider => 'upstart',
  }

  if $platform != 'development' {
    Service[$title] {
      ensure => running
    }
  }

}
