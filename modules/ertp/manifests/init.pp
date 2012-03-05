class ertp::config {
  file { "/etc/gds-ertp-config.properties":
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-config.properties.${govuk_platform}",
      "puppet:///modules/ertp/gds-ertp-config.properties"
    ]
  }
}

