class ertp {
}

class places::scripts {
  file {'/etc/init/places.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/places.conf']
  }
}

class ertp-api::scripts {
  file {'/etc/init/ertp-api.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/ertp-api.conf']
  }
}
