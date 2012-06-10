class ertp::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-config.properties.${::govuk_platform}",
      'puppet:///modules/ertp/gds-ertp-config.properties'
    ]
  }
}

class ertp::dwp::api::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-dwp-api-config.properties.${::govuk_platform}",
      'puppet:///modules/ertp/gds-ertp-dwp-api-config.properties'
    ]
  }
}

class ertp::ems::api::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-ems-api-config.properties.${::govuk_platform}",
      'puppet:///modules/ertp/gds-ertp-ems-api-config.properties'
    ]
  }
}

class ertp::citizen::api::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-citizen-api-config.properties.${::govuk_platform}",
      'puppet:///modules/ertp/gds-ertp-citizen-api-config.properties'
    ]
  }
}