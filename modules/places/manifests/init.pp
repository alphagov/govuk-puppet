class places {
}

class places::scripts {
  file {'/etc/init/places.conf':
    ensure => present,
    source => ['puppet:///modules/places/places.conf']
  }
}
