class ertp {
}

class places::scripts {
  file {'/etc/init/places.conf':
    ensure => present,
    source => ['puppet:///modules/ertp/places.conf']
  }
}
