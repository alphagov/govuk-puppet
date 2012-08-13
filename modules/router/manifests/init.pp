class router {
  file { '/etc/gdsrouter.properties':
    ensure => present,
    source => [
      "puppet:///modules/router/gdsrouter.properties.${::govuk_provider}.${::govuk_platform}",
      "puppet:///modules/router/gdsrouter.properties.${::govuk_platform}",
      'puppet:///modules/router/gdsrouter.properties'
    ]
  }
}
