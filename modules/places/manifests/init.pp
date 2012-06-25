class places {
}

class places::scripts {
  file {'/etc/init/places.conf':
    ensure => present,
    source => ['puppet:///modules/places/places.conf']
  }
}

class places::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/places/gds-ertp-config.properties.${::govuk_platform}",
      'puppet:///modules/places/gds-ertp-config.properties'
    ]
  }
}