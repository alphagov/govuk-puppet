class elms::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/elms/gds-ertp-config.properties.${::govuk_platform}",
      'puppet:///modules/elms/gds-ertp-config.properties'
    ]
  }
}
