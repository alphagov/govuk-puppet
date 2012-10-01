class licensify::config {

  $aws_access_key_id = extlookup('aws_access_key_id', '')
  $aws_secret_key = extlookup('aws_secret_key', '')

  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
                "puppet:///modules/licensify/gds-ertp-config.properties.${::govuk_platform}.${::govuk_provider}",
                "puppet:///modules/licensify/gds-ertp-config.properties.${::govuk_platform}",
                ]
  }

}
