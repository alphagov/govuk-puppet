class licensify::config {

  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-ertp-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-ertp-config.properties.${::govuk_platform}",
                ]
  }

}
