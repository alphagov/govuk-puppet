class ertp::config {
  file { '/etc/gds-ertp-config.properties':
    ensure => present,
    source => [
      "puppet:///modules/ertp/gds-ertp-config.properties.${::govuk_platform}",
      'puppet:///modules/ertp/gds-ertp-config.properties'
    ]
  }
}

class ertp::scripts {
  file {'/etc/init/ertp.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp.conf']
  }

  file {'/etc/init/ertp-ems-admin.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-ems-admin.conf']
  }
}

class places::scripts {
  file {'/etc/init/places.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/places.conf']
  }
}
