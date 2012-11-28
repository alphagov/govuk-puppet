class ertp {
}

class ertp::scripts {
  file {'/etc/init/ertp.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-frontend.conf']
  }

  file {'/etc/init/ertp-admin.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-admin.conf']
  }
}

class ertp::dwp::scripts {
  file {'/etc/init/ertp-dwp-feed.conf':
    ensure => present,
    source => [
      "puppet:///modules/ertp/ertp-dwp-feed.conf.${::govuk_platform}",
      'puppet:///modules/ertp/ertp-dwp-feed.conf'
    ]
  }
}

class ertp::api::scripts {
  file {'/etc/init/ertp-api.conf':
    ensure => present,
    source => [
      'puppet:///modules/ertp/ertp-api.conf',
      'puppet:///modules/ertp/ertp-stats-api.conf'
    ]
  }
}

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

class ertp::ero::api::config {
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
